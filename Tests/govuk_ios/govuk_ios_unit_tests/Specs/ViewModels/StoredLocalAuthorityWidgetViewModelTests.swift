import Foundation
import Testing

@testable import GOVKit
@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct StoredLocalAuthorityWidgetViewModelTests {
    let coreData = CoreDataRepository.arrangeAndLoad

    @Test
    func openURL_opensCorrectURL() async throws {
        let localAuthorityItem = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        localAuthorityItem.name = "Test Local Authority"
        localAuthorityItem.slug = "slug"
        localAuthorityItem.homepageUrl = "https://www.gov.uk/some-url"
        localAuthorityItem.tier = "unitary"
        var openedURL: URL?
        let expectedItem = StoredLocalAuthorityCardModel.arrange
        await withCheckedContinuation { continuation in
            let sut = StoredLocalAuthorityWidgetViewModel(
                analyticsService: MockAnalyticsService(),
                localAuthorities: [localAuthorityItem],
                openURLAction: { localUrl in
                    openedURL = localUrl
                    continuation.resume()
                },
                openEditViewAction: {}
            )
            sut.open(item: expectedItem)
        }
        #expect(openedURL?.absoluteString == expectedItem.homepageUrl)
    }


    @Test
    func openURL_tracksEventCorrectly() {
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
            openURLAction: { _ in },
            openEditViewAction: {}
        )
        let item = StoredLocalAuthorityCardModel.arrange
        sut.open(item: item)
        let receivedTrackingTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTrackingTitle == item.name)

    }

    @Test
    func convertModel_unitaryAuthority_returnsExpectedResult() {
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
            openURLAction: { _ in },
            openEditViewAction: {}
        )

        let result = sut.cardModels()
        #expect(result.count == 1)
        #expect(result.first?.homepageUrl == "https://www.towerhamlets.gov.uk")
        #expect(result.first?.description == "Find services for your area on the London Borough of Tower Hamlets website")
    }

    @Test
    func convertModel_twoTier_returnsExpectedResult() {
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
            openURLAction: { _ in },
            openEditViewAction: {}
        )

        let result = sut.cardModels()
        #expect(result.count == 2)
        #expect(result.first?.homepageUrl == "https://www.derbyshire.gov.uk/")
        #expect(result.first?.description == "Find services like education, social care and transport on the Derbyshire County Council website")
    }
}
