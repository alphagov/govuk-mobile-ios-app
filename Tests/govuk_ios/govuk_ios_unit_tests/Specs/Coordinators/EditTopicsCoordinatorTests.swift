import Testing
import UIKit
@testable import govuk_ios

@Suite
@MainActor
struct EditTopicsCoordinatorTests {
    
    @Test
    func start_setsEditTopicsView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        
        mockViewControllerBuilder._stubbedEditTopicsViewController = expectedViewController
        
        let subject = EditTopicsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            topicsService: mockTopicsService,
            viewControllerBuilder: mockViewControllerBuilder,
            dismissed: { }
        )
        
        subject.start()
        
        #expect(navigationController.viewControllers.first == expectedViewController)
    }
    
    @Test
    func dragToDismiss_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinator = MockBaseCoordinator()

        mockViewControllerBuilder._stubbedEditTopicsViewController = expectedViewController

        let dismissed = await withCheckedContinuation { continuation in
            let subject = EditTopicsCoordinator(
                navigationController: navigationController,
                analyticsService: mockAnalyticsService,
                topicsService: mockTopicsService,
                viewControllerBuilder: mockViewControllerBuilder,
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            mockCoordinator.start(subject)

            subject.presentationControllerDidDismiss(subject.root.presentationController!)
        }

        #expect(dismissed)
    }
    
    @Test
    func doneButton_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        let expectedViewController = UIViewController()
        let mockNavigationController = MockNavigationController()
        let mockCoordinator = MockBaseCoordinator()

        mockViewControllerBuilder._stubbedEditTopicsViewController = expectedViewController
        var subject: EditTopicsCoordinator!
        let dismissed = await withCheckedContinuation { continuation in
            subject = EditTopicsCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
                topicsService: mockTopicsService,
                viewControllerBuilder: mockViewControllerBuilder,
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            mockCoordinator.start(subject)

            //Simulate view controller calling close
            mockViewControllerBuilder._receivedDismissAction?()
        }

        #expect(dismissed)
        #expect(mockCoordinator._childDidFinishReceivedChild == subject)
        #expect(subject != nil)
        #expect(mockNavigationController._dismissCalled)
        #expect(mockNavigationController._receivedDismissAnimated == true)
    }
}
