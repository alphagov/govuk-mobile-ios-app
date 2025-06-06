import Testing

@testable import govuk_ios

struct AmbiguousAddressSelectionViewModelTests {

    @Test
    func confirmButtonAction_savesLocalAuthority_andNavigateToSuccessView() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        var navigatedToConfirmationView = false
        let authorityOne = Authority(
            name: "name1",
            homepageUrl: "homepageURL1",
            tier: "tier1",
            slug: "slug1"
        )
        let authorityTwo = Authority(
            name: "name2",
            homepageUrl: "homepageUR2",
            tier: "tier2",
            slug: "slug2"
        )
        let addressOne = LocalAuthorityAddress(
            address: "address1",
            slug: "slug1",
            name: "name1"
        )
        let addressTwo = LocalAuthorityAddress(
            address: "address2",
            slug: "slug2",
            name: "name2"
        )

        let sut = AmbiguousAddressSelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [authorityOne, authorityTwo],
                addresses: [addressOne, addressTwo]
            ),
            navigateToConfirmationView: {_ in
                navigatedToConfirmationView = true
            },
            dismissAction: {}
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(mockLocalAuthorityService._savedAuthority?.slug == "slug1")
        #expect(navigatedToConfirmationView)
    }

    @Test
    func confirmButtonAction_firesNavigationEvent() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        let mockAnalyticsService = MockAnalyticsService()
        let authorityOne = Authority(
            name: "name1",
            homepageUrl: "homepageURL1",
            tier: "tier1",
            slug: "slug1"
        )
        let authorityTwo = Authority(
            name: "name2",
            homepageUrl: "homepageUR2",
            tier: "tier2",
            slug: "slug2"
        )
        let addressOne = LocalAuthorityAddress(
            address: "address1",
            slug: "slug1",
            name: "name1"
        )
        let addressTwo = LocalAuthorityAddress(
            address: "address2",
            slug: "slug2",
            name: "name2"
        )

        let sut = AmbiguousAddressSelectionViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [authorityOne, authorityTwo],
                addresses: [addressOne, addressTwo]
            ),
            navigateToConfirmationView: {_ in },
            dismissAction: { }
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.localAuthority.localized("addressSelectionPrimaryButtonTitle"))

    }
}
