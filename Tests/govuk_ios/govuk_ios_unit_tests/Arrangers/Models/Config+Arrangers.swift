import Foundation

@testable import govuk_ios

extension Config {
    static var arrange: Config {
        .arrange()
    }

    static func arrange(available: Bool = true,
                        minimumVersion: String = "0.0.1",
                        recommendedVersion: String = "0.0.1",
                        releaseFlags: [String: Bool] = [:],
                        lastUpdated: String = "test") -> Config {
        .init(
            available: available,
            minimumVersion: minimumVersion,
            recommendedVersion: recommendedVersion,
            releaseFlags: releaseFlags,
            lastUpdated: lastUpdated
        )
    }
}
