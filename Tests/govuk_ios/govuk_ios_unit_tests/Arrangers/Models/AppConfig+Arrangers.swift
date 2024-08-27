import Foundation

@testable import govuk_ios

extension AppConfig {
    static var arrange: AppConfig {
        arrange()
    }

    static func arrange(platform: String = "iOS",
                        config: Config = .arrange,
                        signature: String = "") -> AppConfig {
        .init(
            platform: platform,
            config: config,
            signature: signature
        )
    }
}
