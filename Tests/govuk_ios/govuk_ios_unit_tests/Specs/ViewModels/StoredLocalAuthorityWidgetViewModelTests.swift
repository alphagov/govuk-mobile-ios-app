import Testing

@testable import GOVKit
@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct StoredLocalAuthorityWidgetViewModelTests {
    let coreData = CoreDataRepository.arrangeAndLoad

    @Test
    func openURL_opensCorrectURL() async throws {
        let mockURLOpener: MockURLOpener = MockURLOpener()

        let localAuthorityItem = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        localAuthorityItem.name = "Test Local Authority"
        localAuthorityItem.slug = "slug"
        localAuthorityItem.homepageUrl = "https://www.gov.uk/some-url"
        localAuthorityItem.tier = "unitary"

        let sut = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: [localAuthorityItem],
            urlOpener: mockURLOpener,
            openEditViewAction: {}
        )

        sut.openURL(url: "https://www.gov.uk/some-url", title: "")
        let expectedUrl = "https://www.gov.uk/some-url"
        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == expectedUrl)
    }


    @Test
    func openURL_tracksEventCorrectly() async throws {
        let mockURLOpener: MockURLOpener = MockURLOpener()
        let mockAnalyticsService: MockAnalyticsService = MockAnalyticsService()
        let localAuthorityItem = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        localAuthorityItem.name = "Test Local Authority"
        localAuthorityItem.slug = "slug"
        localAuthorityItem.homepageUrl = "https://www.gov.uk/some-url"
        localAuthorityItem.tier = "unitary"

        let sut = StoredLocalAuthorityWidgetViewModel(
            analyticsService: mockAnalyticsService,
            localAuthorities: [localAuthorityItem],
            urlOpener: mockURLOpener,
            openEditViewAction: {}
        )
        sut.openURL(
            url: "https://www.gov.uk/some-url",
            title: "test"
        )
        let receivedTrackingTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTrackingTitle == "test")

    }

    @Test
    func convertModel_unitaryAuthority_returnsExpectedResult() async throws {
        let mockAuthorityItem = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        mockAuthorityItem.name = "London Borough of Tower Hamlets"
        mockAuthorityItem.slug = "tower-hamlets"
        mockAuthorityItem.homepageUrl = "https://www.towerhamlets.gov.uk"
        mockAuthorityItem.tier = "unitary"

        let sut = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: [mockAuthorityItem],
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )

        let result = sut.returnCards()
        #expect(result.count == 1)
        #expect(result.first?.homepageUrl == "https://www.towerhamlets.gov.uk")
        #expect(result.first?.description == "Find services for your area on the London Borough of Tower Hamlets website")
    }

    @Test
    func convertModel_twoTier_returnsExpectedResult() async throws {

        let parentAuthority = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        parentAuthority.name = "Derbyshire County Council"
        parentAuthority.slug =  "derbyshire"
        parentAuthority.homepageUrl = "https://www.derbyshire.gov.uk/"
        parentAuthority.tier = "county"

        let childAuthority = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        childAuthority.name = "Derbyshire Dales District Council"
        childAuthority.slug = "derbyshire-dales"
        childAuthority.homepageUrl = "https://www.derbyshiredales.gov.uk/"
        childAuthority.tier = "district"
        childAuthority.parent = parentAuthority

        var authorityItems: [LocalAuthorityItem] = []
        authorityItems.append(parentAuthority)
        authorityItems.append(childAuthority)

        let sut = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: authorityItems,
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )

        let result = sut.returnCards()
        #expect(result.count == 2)
        #expect(result.first?.homepageUrl == "https://www.derbyshire.gov.uk/")
        #expect(result.first?.description == "Find services like education, social care and transport on the Derbyshire County Council website")
    }
}
