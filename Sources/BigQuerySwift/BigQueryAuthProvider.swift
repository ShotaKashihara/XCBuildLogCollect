import Foundation

import OAuth2

/// Response to retrieving authentication token
///
/// - token: Successful response will contain the authentication token
/// - error: Unsuccessful response will contain the error
public enum AuthResponse {
    case token(String)
    case error(Error)
}

/// Handles authenticating a service account
public struct BigQueryAuthProvider {
    /// Set scope to be BigQuery
    private let scopes = [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/bigquery.insertdata",
    ]

    public init() {}

    /// Get an authentication token to be used in API calls.
    /// The credentials file is expected to be in the same directory as the
    /// running binary (ie. $pwd/credentials.json)
    ///
    /// - Parameter completionHandler: Called upon completion
    /// - Throws: If JWT creation fails
    public func getAuthenticationToken(data: Data? = nil, completionHandler: @escaping (AuthResponse) -> Void) throws {
        let tokenProvider: ServiceAccountTokenProvider
        if let data = data {
            guard let provider = ServiceAccountTokenProvider(
                credentialsData: data,
                scopes: scopes
            ) else {
                fatalError("Failed to create token provider")
            }
            tokenProvider = provider
        } else {
            // Get current directory
            let currentDirectoryURL = URL(
                fileURLWithPath: FileManager.default.currentDirectoryPath
            )
            // Get URL of credentials file
            let credentialsURL = currentDirectoryURL.appendingPathComponent("credentials.json")
            guard let provider = ServiceAccountTokenProvider(
                credentialsURL: credentialsURL,
                scopes: scopes
            ) else {
                fatalError("Failed to create token provider")
            }
            tokenProvider = provider
        }

        // Request token
        try tokenProvider.withToken { (token, error) in
            if let token = token {
                completionHandler(.token(token.AccessToken!))
            } else {
                completionHandler(.error(error!))
            }
        }
    }
}
