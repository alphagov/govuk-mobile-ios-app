import Testing

@testable import govuk_ios

struct AmbiguousAuthoritySelectionViewModelTests {

    @Test
    func subtitle_renders_postcode_correctly() {
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: MockLocalAuthorityService(),
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [],
                addresses: []
            ),
            postCode: "BH22 8UB",
            selectAddressAction: { },
            dismissAction: { }
        )

        #expect(sut.subtitle == "Your postcode BH22 8UB is shared by more than one local council")
    }

    @Test
    func confirmButtonAction_savesLocalAuthority_andDismisses() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        var dismissCalled = false
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [],
                addresses: []
            ),
            postCode: "SW11 5EW",
            selectAddressAction: { },
            dismissAction: {
                dismissCalled = true
            }
        )
        sut.selectedAuthority = Authority(
            name: "name1",
            homepageUrl: "homepageURL",
            tier: "tier1",
            slug: "slug1"
        )
        sut.confirmButtonModel.action()
        #expect(mockLocalAuthorityService._savedAuthority?.slug == "slug1")
        #expect(dismissCalled)
    }

    @Test
    func selectAddressButton_callsSelectAddressAction() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        var selectAddressCalled = false
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [],
                addresses: []
            ),
            postCode: "SW11 5EW",
            selectAddressAction: {
                selectAddressCalled = true
            },
            dismissAction: { }
        )
        sut.selectAddressButtonModel.action()
        #expect(selectAddressCalled)
    }

}
