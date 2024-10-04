import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct HomeCoordinatorTests {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    @MainActor
    func start_setsHomeViewController() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedHomeViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicsService: MockTopicsService()
        )
        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }
}
