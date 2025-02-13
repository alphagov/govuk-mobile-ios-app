import Foundation

@testable import govuk_ios

extension AppConfig: @retroactive Equatable {
    public static func == (lhs: AppConfig, rhs: AppConfig) -> Bool {
        lhs.platform == rhs.platform &&
        lhs.config == rhs.config
    }
}

extension Config: @retroactive Equatable {
    public static func == (lhs: Config, rhs: Config) -> Bool {
        lhs.available == rhs.available &&
        lhs.releaseFlags == rhs.releaseFlags &&
        lhs.minimumVersion == rhs.minimumVersion &&
        lhs.recommendedVersion == rhs.recommendedVersion &&
        lhs.releaseFlags == rhs.releaseFlags &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.searchApiUrl == rhs.searchApiUrl &&
        lhs.homeWidgets == rhs.homeWidgets
    }
}

extension TopicResponseItem: @retroactive Equatable {
    public static func == (lhs: TopicResponseItem, rhs: TopicResponseItem) -> Bool {
        lhs.ref == rhs.ref &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description
    }
}
