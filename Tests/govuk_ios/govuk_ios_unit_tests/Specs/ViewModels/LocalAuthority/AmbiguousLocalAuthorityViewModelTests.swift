import Testing

@testable import govuk_ios

struct AmbiguousLocalAuthorityViewModelTests {

    @Test
    func subtitle_renders_postcode_correctly() {
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: MockLocalAuthorityService(),
            localAuthorities: [],
            postCode: "SW11 5EW",
            selectAddressAction: { },
            dismissAction: { }
        )

        print(sut.subtitle)
    }

}
