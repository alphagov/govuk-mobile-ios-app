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
            localAuthoritySelected: {_ in},
            selectAddressAction: { },
            dismissAction: { }
        )

        #expect(sut.subtitle == "Your postcode BH22 8UB is shared by more than one local council")
    }

    @Test
    func confirmButtonAction_savesLocalAuthority_andNavigatedToSuccesView() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        var navigatedToSuccesView = false
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [],
                addresses: []
            ),
            postCode: "SW11 5EW",
            localAuthoritySelected: {_ in
                navigatedToSuccesView = true
            },
            selectAddressAction: { },
            dismissAction: {}
        )
        sut.selectedAuthority = Authority(
            name: "name1",
            homepageUrl: "homepageURL",
            tier: "tier1",
            slug: "slug1"
        )
        sut.confirmButtonModel.action()
        #expect(mockLocalAuthorityService._savedAuthority?.slug == "slug1")
        #expect(navigatedToSuccesView)
    }

    @Test
    func confirmButtonAction_firesNavigationEvent() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [],
                addresses: []
            ),
            postCode: "SW11 5EW",
            localAuthoritySelected: {_ in},
            selectAddressAction: { },
            dismissAction: { }
        )
        sut.selectedAuthority = Authority(
            name: "name1",
            homepageUrl: "homepageURL",
            tier: "tier1",
            slug: "slug1"
        )
        sut.confirmButtonModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.localAuthority.localized("ambiguousLocalAuthorityPrimaryButtonTitle"))
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
            localAuthoritySelected: {_ in},
            selectAddressAction: {
                selectAddressCalled = true
            },
            dismissAction: { }
        )
        sut.selectAddressButtonModel.action()
        #expect(selectAddressCalled)
    }

    @Test
    func selectAddressButton_firesNavigationEvent() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = AmbiguousAuthoritySelectionViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [],
                addresses: []
            ),
            postCode: "SW11 5EW",
            localAuthoritySelected: {_ in },
            selectAddressAction: { },
            dismissAction: { }
        )
        sut.selectAddressButtonModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.localAuthority.localized("ambiguousLocalAuthoritySecondaryButtonTitle"))

    }

}
