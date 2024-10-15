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
            topics: [],
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

        mockViewControllerBuilder._stubbedEditTopicsViewController = expectedViewController

        let dismissed = await withCheckedContinuation { continuation in
            let subject = EditTopicsCoordinator(
                navigationController: navigationController,
                analyticsService: mockAnalyticsService,
                topicsService: mockTopicsService,
                viewControllerBuilder: mockViewControllerBuilder,
                topics: [],
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
    func doneButton_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        let expectedViewController = UIViewController()
        let mockNavigationController = MockNavigationController()

        mockViewControllerBuilder._stubbedEditTopicsViewController = expectedViewController

        _ = await withCheckedContinuation { continuation in
            let subject = EditTopicsCoordinator(
                navigationController: mockNavigationController,
                analyticsService: mockAnalyticsService,
                topicsService: mockTopicsService,
                viewControllerBuilder: mockViewControllerBuilder,
                topics: [],
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            subject.start()
            
            //Simulate view controller calling close
            mockViewControllerBuilder._receivedDoneButtonAction?()
        }

        #expect(mockNavigationController._dismissCalled)
        #expect(mockNavigationController._receivedDismissAnimated == true)
    }
}
