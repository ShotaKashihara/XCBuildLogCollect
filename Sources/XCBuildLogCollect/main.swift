import Foundation
import XCLogParser
import BigQuerySwift

let data = """
{
  "type": "service_account",
  "project_id": "xcbuild-log-collect",
  "private_key_id": "1eae983ca2681d48db8d41eb407feedb13df6f16",
  "private_key": "",
  "client_email": "bigquery-swift@xcbuild-log-collect.iam.gserviceaccount.com",
  "client_id": "102946377894865288467",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/bigquery-swift%40xcbuild-log-collect.iam.gserviceaccount.com"
}
""".data(using: .utf8)

let semaphore = DispatchSemaphore(value: 0)
let provider = BigQueryAuthProvider()
var token = ""
try provider.getAuthenticationToken(data: data, completionHandler: { response in
    switch response {
    case .token(let string):
        token = string
        semaphore.signal()
    case .error(let error):
        fatalError(error.localizedDescription)
    }
})
semaphore.wait()
struct Log: Codable {
    let title: String
    let section: Log2
    let titles: [String]
}
struct Log2: Codable {
    let title: String
    let section: Log3
}
struct Log3: Codable {
    let title: String
}
let client = BigQueryClient<Log>(
    authenticationToken: token,
    projectID: "xcbuild-log-collect",
    datasetID: "test",
    tableName: "log2"
)
let rows: [Log] = [
    .init(
        title: "a",
        section: .init(
            title: "b",
            section: .init(title: "c")),
            titles: ["a,a", "b,b", "ccc"
        ]
    )
]

//mercury4th@cloudshell:~ (xcbuild-log-collect)$ bq show --schema --format=prettyjson xcbuild-log-collect:test.log
//[
//  {
//    "mode": "NULLABLE",
//    "name": "title",
//    "type": "STRING"
//  },
//  {
//    "fields": [
//      {
//        "mode": "NULLABLE",
//        "name": "title",
//        "type": "STRING"
//      },
//      {
//        "fields": [
//          {
//            "mode": "NULLABLE",
//            "name": "title",
//            "type": "STRING"
//          }
//        ],
//        "mode": "NULLABLE",
//        "name": "section",
//        "type": "RECORD"
//      }
//    ],
//    "mode": "NULLABLE",
//    "name": "section",
//    "type": "RECORD"
//  },
//  {
//    "mode": "REPEATED",
//    "name": "titles",
//    "type": "STRING"
//  }
//]

try client.insert(rows: rows) { response in
    switch response {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
    semaphore.signal()
}

semaphore.wait()



//let projectName = "Visit"
//let output = "visit-activity.log"
//
//let logOptions = LogOptions(
//    projectName: projectName,
//    xcworkspacePath: "",
//    xcodeprojPath: "",
//    derivedDataPath: "",
//    logManifestPath: ""
//)
//let actionOptions = ActionOptions(
//    reporter: .json,
//    outputPath: output,
//    redacted: false,
//    withoutBuildSpecificInformation: true
//)
//
//let logFinder = LogFinder()
//let activityLogParser = ActivityParser()
//
//let logURL = try logFinder.findLatestLogWithLogOptions(logOptions)
//let activityLog: IDEActivityLog = try activityLogParser.parseActivityLogInURL(
//    logURL,
//    redacted: actionOptions.redacted,
//    withoutBuildSpecificInformation: actionOptions.withoutBuildSpecificInformation)
//
//
//struct WorkspaceSchema {
//    /// `Visit`
//    let workspace: String
//    /// `Visit Intern Qa`
//    let scheme: String
//    /// `Shota ã®iPhone 12 Pro`
//    let destination: String
//    /// `40` (sec)
//    let buildTime: Int
//    let wasFetchedFromCache: Bool
//    /// activityLog.mainSection.localizedResultString.replacingOccurrences(of: "Build ", with: "")
//    let buildStatus: String
//}
//
//struct ProjectSchema {
//    /// `Visit`
//    let project: String
//    /// `Intern Qa Debug`
//    let configuration: String
//    /// `Shota ã®iPhone 12 Pro`
//    let destination: String
//    /// `iOS 15.0`
//    let sdk: String?
//    /// `40` (sec)
//    let buildTime: Int
//}
//
//func description(log: IDEActivityLogSection, a: Bool = false) {
//
//    if a || log.title.hasPrefix("Build target Visit") {
//        for _ in 0..<log.sectionType {
//            print("  ", terminator: "")
//        }
//        print(log.title, log.subtitle, log.timeStoppedRecording - log.timeStartedRecording)
//    }
//
//
//    // sectionType=0 Build Visit Visit Qa  0 116.53910100460052
//    // sectionType=1 Prepare build Workspace Visit | Scheme Visit Visit Qa | Destination Shota ã®iPhone 12 Pro 1 116.49032497406006
//
//    for s in log.subSections {
//        description(log: s, a: a || log.title.hasPrefix("Build target Visit"))
//    }
//}
//
//description(log: activityLog.mainSection)
////
////let provider = BigQueryAuthProvider()
////try! provider.getAuthenticationToken { response in
////    switch response {
////    case .token(let token):
////        // Your token to be passed into BigQueryClient
////        print(token)
////    case .error(_):
////        fatalError("Something went wrong.")
////    }
////}
