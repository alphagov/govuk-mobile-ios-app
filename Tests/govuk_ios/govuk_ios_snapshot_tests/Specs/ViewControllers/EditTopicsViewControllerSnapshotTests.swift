import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
final class EditTopicsViewControllerSnapshotTests: SnapshotTestCase {
    
    private let mockTopicsService = MockTopicsService()
    
    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark
        )
    }
    
    private func viewController() -> UIViewController {
        let coreData = CoreDataRepository.arrangeAndLoad
        mockTopicsService._stubbedFetchAllTopics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        let viewModel = EditTopicsViewModel(
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            dismissAction: { }
        )
        let view = EditTopicsView(
            viewModel: viewModel
        )
        
        return HostingViewController(rootView: view)
    }
}
