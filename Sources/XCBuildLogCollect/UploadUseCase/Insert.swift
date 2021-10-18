import Foundation
import OAuth2
import BigQueryClient

func insert<T: Encodable>(
    credentialsURL: URL,
    projectId: String,
    datasetId: String,
    tableId: String,
    rows: [T]
) throws {
    print(credentialsURL.absoluteString)
    guard let tokenProvider = ServiceAccountTokenProvider(credentialsURL: credentialsURL, scopes: [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/bigquery.insertdata",
    ]) else {
        throw NSError(domain: "ServiceAccountTokenProvider is do not initialized", code: -1, userInfo: [:])
    }
    let bigquery = try Bigquery(tokenProvider: tokenProvider)
    let request = Bigquery.TableDataInsertAllRequest(
        ignoreUnknownValues: true,
        kind: "bigquery#tableDataInsertAllRequest",
        insertRows: rows,
        skipInvalidRows: false,
        templateSuffix: nil
    )
    let parameters = Bigquery.TabledataInsertAllParameters(
        datasetId: datasetId,
        projectId: projectId,
        tableId: tableId
    )
    let semaphore = DispatchSemaphore(value: 0)
    try bigquery.tabledata_insertAll(
        request: request,
        parameters: parameters) { response, error in
            if let errors = response?.insertErrors {
                dump(errors)
            }
            semaphore.signal()
        }
    semaphore.wait()
}
