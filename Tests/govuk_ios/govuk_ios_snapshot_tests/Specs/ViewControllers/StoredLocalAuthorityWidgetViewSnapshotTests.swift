import Foundation
import XCTest
import CoreData
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class StoredLocalAuthorityWidgetViewSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_unitary_light_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let localAuthorityItem = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        localAuthorityItem.name = "Test Local Authority"
        localAuthorityItem.slug = "slug"
        localAuthorityItem.homepageUrl = "https://www.gov.uk/some-url"
        localAuthorityItem.tier = "unitary"
        let viewModel = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: [localAuthorityItem],
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )
        let view = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_unitary_dark_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let localAuthorityItem = LocalAuthorityItem(
            context: coreData.backgroundContext
        )
        localAuthorityItem.name = "Test Local Authority"
        localAuthorityItem.slug = "slug"
        localAuthorityItem.homepageUrl = "https://www.gov.uk/some-url"
        localAuthorityItem.tier = "unitary"
        let viewModel = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: [localAuthorityItem],
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )
        let view = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_twoTier_light_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad

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



        let viewModel = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: authorityItems,
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )
        let view = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_twoTier_dark_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad

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



        let viewModel = StoredLocalAuthorityWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorities: authorityItems,
            urlOpener: MockURLOpener(),
            openEditViewAction: {}
        )
        let view = StoredLocalAuthorityWidgetView(
            viewModel: viewModel
        )
        VerifySnapshotInNavigationController(
            viewController: HostingViewController(rootView: view),
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}
