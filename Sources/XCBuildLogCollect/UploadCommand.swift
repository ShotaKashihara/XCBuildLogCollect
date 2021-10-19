import Foundation
import ArgumentParser
import XCLogParser

struct UploadCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "upload",
        abstract: "XCActivityLog を解析して BigQuery にアップロードします"
    )

    @Option(name: .long, help: "BigQuery の projectId")
    var projectId: String

    @Option(name: .long, help: "BigQuery の datasetId")
    var datasetId: String

    @Option(name: .long, help: "BigQuery の tableId")
    var tableId: String

    @Option(name: .long, help: "The path to a .xcactivitylog file.")
    var file: String?

    @Option(name: .customLong("derived_data"),
            help: """
    The path to the DerivedData directory.
    Use it if it's not the default ~/Library/Developer/Xcode/DerivedData/.
    """)
    var derivedData: String?

    @Option(name: .long,
            help: """
    The name of an Xcode project. The tool will try to find the latest log folder
    with this prefix in the DerivedData directory. Use with `--strictProjectName`
    for stricter name matching.
    """)
    var project: String?

    @Option(name: .long,
            help: """
    The path to the .xcworkspace folder. Used to find the Derived Data project directory
    if no `--project` flag is present.
    """)
    var workspace: String?

    @Option(name: .long,
            help: """
    The path to the .xcodeproj folder. Used to find the Derived Data project directory
    if no `--project` and no `--workspace` flag is present.
    """)
    var xcodeproj: String?

    @Flag(name: .customLong("strictProjectName"),
          help: """
    Use strict name testing when trying to find the latest version of the project
    in the DerivedData directory.
    """)
    var strictProjectName: Bool = false

    @Option(name: .customLong("credentials_path"),
            help: """
    BigQuery の認証情報(JSON) のパス
    """)
    var credentialsPath: String

    mutating func validate() throws {
        if !hasValidLogOptions() {
            throw ValidationError("""
            Please, provide a way to locate the .xcactivity log of your project.
            You can use --file or --project or --workspace or --xcodeproj.
            Type `xclogparser help dump` to get more information.`
            """)
        }
    }

    private func hasValidLogOptions() -> Bool {
        return !file.isBlank || !project.isBlank || !workspace.isBlank || !xcodeproj.isBlank
    }

    func run() throws {
        let logOptions = LogOptions(
            projectName: project ?? "",
            xcworkspacePath: workspace ?? "",
            xcodeprojPath: xcodeproj ?? "",
            derivedDataPath: derivedData ?? "",
            xcactivitylogPath: file ?? "",
            strictProjectName: strictProjectName
        )

        let buildLogs = try buildLogs(logOptions)

        try insert(
            credentialsURL: URL(fileURLWithPath: credentialsPath),
            projectId: projectId,
            datasetId: datasetId,
            tableId: tableId,
            rows: buildLogs
        )
    }
}
