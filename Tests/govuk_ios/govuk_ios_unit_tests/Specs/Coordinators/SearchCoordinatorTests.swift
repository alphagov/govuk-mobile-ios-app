import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct SearchCoordinatorTests {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_setsSearchViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedSearchViewController = expectedViewController

        let subject = SearchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(),
            dismissed: { }
        )

        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func dragToDismiss_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedSearchViewController = expectedViewController

        let dismissed = await withCheckedContinuation { continuation in
            let subject = SearchCoordinator(
                navigationController: navigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: mockAnalyticsService,
                searchService: MockSearchService(),
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            subject.start()

            subject.presentationControllerDidDismiss(subject.root.presentationController!)
        }

        #expect(dismissed)
    }

    @Test
    func dismissModal_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let mockNavigationController = MockNavigationController()

        mockViewControllerBuilder._stubbedSearchViewController = expectedViewController

        _ = await withCheckedContinuation { continuation in
            let subject = SearchCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: mockAnalyticsService,
                searchService: MockSearchService(),
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            subject.start()

            //Simulate view controller calling close
            mockViewControllerBuilder._receivedSearchDismissAction?()
        }
        #expect(mockNavigationController._dismissCalled)
        #expect(mockNavigationController._receivedDismissAnimated == true)
    }
}
