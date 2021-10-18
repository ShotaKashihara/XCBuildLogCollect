import ArgumentParser

struct MainCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "xcbuildlogcollect",
        subcommands: [
            UploadCommand.self,
        ]
    )
}

MainCommand.main()
