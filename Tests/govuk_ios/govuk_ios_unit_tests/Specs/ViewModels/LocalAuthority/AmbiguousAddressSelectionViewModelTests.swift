import Testing

@testable import govuk_ios

struct AmbiguousAddressSelectionViewModelTests {

    @Test
    func confirmButtonAction_savesLocalAuthority_andDismisses() {
        let mockLocalAuthorityService = MockLocalAuthorityService()
        var dismissCalled = false
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
            dismissAction: {
                dismissCalled = true
            }
        )
        sut.selectedAddress = addressOne
        sut.confirmButtonModel.action()
        #expect(mockLocalAuthorityService._savedAuthority?.slug == "slug1")
        #expect(dismissCalled)
    }

}
