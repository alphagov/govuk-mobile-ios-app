import Foundation
import Testing

@testable import GOVKit

@testable import govuk_ios
struct EmergencyBannerWidgetViewModelTests {

    @Test
    func open_calls_openURLAction_with_banner_url() {
        let bannerURL = Constants.API.govukBaseUrl
        var expectedURL: URL?
        let sut = EmergencyBannerWidgetViewModel(
            banner: .init(
                id: "emergency_two",
                title: "National Emergency",
                body: "This is a Level 1 emergency",
                link: .init(title: "More information",
                            url: bannerURL),
                type: "national-emergency",
                allowsDismissal: true
            ),
            analyticsService: MockAnalyticsService(),
            sortPriority: 1,
            openURLAction: { url in
                expectedURL = url
            },
            dismissAction: { }
        )

        sut.open()
        #expect(expectedURL == bannerURL)
    }
}
