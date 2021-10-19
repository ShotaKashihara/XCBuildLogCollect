import Foundation
import XCLogParser

struct BuildLog: Encodable {
    /// timestamp
    let timestamp: TimeInterval
    /// 0
    let sectionType: Int8
    /// `Xcode.IDEActivityLogDomainType.BuildLog`
    let domainType: String
    /// `Visit Intern Qa`
    let title: String
    let subtitle: String
    /// `40` (sec)
    let buildTime: Int
    let timeStartedRecording: Double
    let timeStoppedRecording: Double
    /// false
    let wasFetchedFromCache: Bool
    /// activityLog.mainSection.localizedResultString.replacingOccurrences(of: "Build ", with: "")
    let buildStatus: String?

    init(log: IDEActivityLogSection, timestamp: TimeInterval) {
        self.timestamp = timestamp
        self.sectionType = log.sectionType
        self.domainType = log.domainType
        self.title = log.title
        self.subtitle = log.subtitle
        self.buildTime = Int(log.timeStoppedRecording - log.timeStartedRecording)
        self.timeStartedRecording = log.timeStartedRecording
        self.timeStoppedRecording = log.timeStoppedRecording
        self.wasFetchedFromCache = log.wasFetchedFromCache
        self.buildStatus = log.localizedResultString.replacingOccurrences(of: "Build ", with: "")
    }
}

func buildLogs(_ logOptions: LogOptions) throws -> [BuildLog] {
    let logFinder = LogFinder()
    let activityLogParser = ActivityParser()

    let logURL = try logFinder.findLatestLogWithLogOptions(logOptions)
    let activityLog: IDEActivityLog = try activityLogParser.parseActivityLogInURL(
        logURL,
        redacted: false,
        withoutBuildSpecificInformation: true
    )
    let timestampNow = Date().timeIntervalSince1970
    var buildLogs: [BuildLog] = []
    buildLogs.append(.init(log: activityLog.mainSection, timestamp: timestampNow))
    for s1 in activityLog.mainSection.subSections {
        buildLogs.append(.init(log: s1, timestamp: timestampNow))
        buildLogs.append(contentsOf: s1.subSections.map { .init(log: $0, timestamp: timestampNow) })
    }
    return buildLogs
}
