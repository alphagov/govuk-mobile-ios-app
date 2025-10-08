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
                        lastUpdated: String = "test",
                        searchApiUrl: String? = nil,
                        authenticationIssuerBaseUrl: String = "https://test.com",
                        chatPollIntervalSeconds: TimeInterval? = 3,
                        refreshTokenExpirySeconds: Int? = 3600) -> Config {
        .init(
            available: available,
            minimumVersion: minimumVersion,
            recommendedVersion: recommendedVersion,
            releaseFlags: releaseFlags,
            lastUpdated: lastUpdated,
            searchApiUrl: searchApiUrl,
            authenticationIssuerBaseUrl: authenticationIssuerBaseUrl,
            chatPollIntervalSeconds: chatPollIntervalSeconds,
            refreshTokenExpirySeconds: refreshTokenExpirySeconds,
            alertBanner: .init(id: "1234", body: "test", link: nil),
            chatBanner: .init(
                id: "1234",
                title: "test",
                body: "test",
                link: ChatBanner.Link(
                    title: "test",
                    url: URL(string: "https://test.com")!)
            ),
            userFeedbackBanner: .init(
                body: "test",
                link: UserFeedbackBanner.Link(
                    title: "test",
                    url: URL(string: "https://test.com")!)
            ),
            chatUrls: ChatURLs(
                termsAndConditions: URL(string: "https://example.com"),
                privacyNotice: URL(string: "https://example.com"),
                about: URL(string: "https://example.com"),
                feedback: URL(string: "https://example.com")
            )
        )
    }
}
