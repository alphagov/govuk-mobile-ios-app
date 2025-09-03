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
                        chatPollIntervalSeconds: Int? = 3) -> Config {
        .init(
            available: available,
            minimumVersion: minimumVersion,
            recommendedVersion: recommendedVersion,
            releaseFlags: releaseFlags,
            lastUpdated: lastUpdated,
            searchApiUrl: searchApiUrl,
            authenticationIssuerBaseUrl: authenticationIssuerBaseUrl,
            chatPollIntervalSeconds: chatPollIntervalSeconds,
            alertBanner: .init(id: "1234", body: "test", link: nil),
            userFeedbackBanner: .init(body: "test",
                                      link: UserFeedbackBanner.Link(
                                        title: "test",
                                        url: URL(string: "https://test.com")!)
                                     )
            chatUrls: ChatURLs(
                termsAndConditions: URL(string: "https://example.com"),
                privacyNotice: URL(string: "https://example.com"),
                about: URL(string: "https://example.com"),
                feedback: URL(string: "https://example.com")
            )
        )
    }
}
