import Foundation

@testable import govuk_ios

extension AppConfig {
    static var arrange: AppConfig {
        arrange()
    }

    static func arrange(platform: String = "iOS",
                        config: Config = .arrange) -> AppConfig {
        .init(
            platform: platform,
            config: config
        )
    }
}
