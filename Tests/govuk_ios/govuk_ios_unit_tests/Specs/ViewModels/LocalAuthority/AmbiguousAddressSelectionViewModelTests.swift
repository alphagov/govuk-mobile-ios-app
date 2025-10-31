import Testing

@testable import govuk_ios


struct AmbiguousAddressSelectionViewModelTests {

    @Test
    func confirmButtonAction_savesLocalAuthority() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
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
            localAuthoritySelected: {_ in},
            dismissAction: {}
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(mockLocalAuthorityService._savedAuthority?.slug == "slug1")
    }

    @Test
    func confirmButtonAction_callsLocalAuthoritySelected() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        var localAuthoritySelectedCalled = false
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
            localAuthoritySelected: { _ in
                localAuthoritySelectedCalled = true
            },
            dismissAction: {}
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(localAuthoritySelectedCalled)
    }

    @Test
    func localAuthoritySelected_returnsCorrectAuthority() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
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
        var expectedLocalAuthority: Authority?

        let sut = AmbiguousAddressSelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: mockLocalAuthorityService,
            ambiguousAuthorities: AmbiguousAuthorities(
                authorities: [authorityOne, authorityTwo],
                addresses: [addressOne, addressTwo]
            ),
            localAuthoritySelected: { authority in
                expectedLocalAuthority = authority
            },
            dismissAction: {}
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(expectedLocalAuthority?.name == "name1")
        #expect(expectedLocalAuthority?.homepageUrl == "homepageURL1")
        #expect(expectedLocalAuthority?.slug == "slug1")
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
            localAuthoritySelected: {_ in },
            dismissAction: { }
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String ==
                String.localAuthority.localized("addressSelectionPrimaryButtonTitle"))

    }
}
