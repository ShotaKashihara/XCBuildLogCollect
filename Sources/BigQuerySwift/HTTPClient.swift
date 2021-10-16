// original by https://github.com/oliveroneill/BigQuerySwift

import Foundation

import SwiftyRequest
import AsyncHTTPClient

/// A protocol for making HTTP requests
public protocol HTTPClient {
    func post(url: String, payload: Data,
              headers: [String:String],
              completionHandler: @escaping (Result<AsyncHTTPClient.HTTPClient.Response, RestError>) -> Void)
}

/// An implementation of HTTPClient using SwiftyRequest
public class SwiftyRequestClient: HTTPClient {
    public func post(url: String, payload: Data,
              headers: [String:String],
                     completionHandler: @escaping (Result<AsyncHTTPClient.HTTPClient.Response, RestError>) -> Void) {
        let request = RestRequest(method: .post, url: url)
        request.messageBody = payload
        request.headerParameters = headers
        request.contentType = "application/json"
        request.response(templateParams: nil, queryItems: nil) { result in
            completionHandler(result)
        }
    }
}
