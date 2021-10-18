import Foundation

public extension Bigquery.TableDataInsertAllRequest {
    init<T: Encodable>(`ignoreUnknownValues`: Bool?, `kind`: String?, insertRows: [T], `skipInvalidRows`: Bool?, `templateSuffix`: String?) {
        let rows: [Row<T>]? = insertRows.map { Row(json: $0) }
        self.init(ignoreUnknownValues: ignoreUnknownValues, kind: kind, rows: rows, skipInvalidRows: skipInvalidRows, templateSuffix: templateSuffix)
    }
}

private extension Bigquery.TableDataInsertAllRequest {
    /// Request body
    /// {
    ///   "rows" : [
    ///     {
    ///       "insertId": string,
    ///       "json: : {
    ///         T
    ///       }
    ///     }
    ///   ]
    /// }
    /// - see:  https://cloud.google.com/bigquery/docs/reference/rest/v2/tabledata/insertAll?apix_params=%7B%22projectId%22%3A%22xcbuild-log-collect%22%2C%22datasetId%22%3A%22test%22%2C%22tableId%22%3A%22log2%22%2C%22resource%22%3A%7B%22ignoreUnknownValues%22%3Afalse%2C%22skipInvalidRows%22%3Afalse%2C%22kind%22%3A%22bigquery%23tableDataInsertAllRequest%22%2C%22rows%22%3A%5B%7B%22title%22%3A%22a%22%7D%5D%7D%7D#request-body
    class Row<T: Encodable>: Bigquery.Object {
        let json: T

        init(json: T) {
            self.json = json
            super.init()
        }

        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }

        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(json, forKey: .json)
            try super.encode(to: encoder)
        }

        enum CodingKeys: String, CodingKey {
            case json
        }
    }
}
