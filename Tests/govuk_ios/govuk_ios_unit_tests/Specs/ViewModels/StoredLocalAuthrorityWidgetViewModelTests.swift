import Testing

@testable import GOVKit
@testable import GOVKitTestUtilities
@testable import govuk_ios

struct StoredLocalAuthrorityWidgetViewModelTests {

    @Test
    func <#test function name#>() async throws {
        let mockURLOpener: MockURLOpener = MockURLOpener()
        let sut = StoredLocalAuthrorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            model: <#LocalAuthorityItem#>,
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )
        let expectedUrl = "https://www.gov.uk/contact/govuk-app?app_version=123%20(456)&phone=Apple%20iPhone16,2%2018.1"
        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == expectedUrl)
    }
}

