import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct EditLocalAuthorityCoordinatorTests {

    @Test
    func start_setsLocalAuthorityPostcodeEntryView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockViewControllerBuilder._stubbedLocalAuthortiyPostcodeEntryViewController = expectedViewController

        let subject = EditLocalAuthorityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            localAuthorityService: MockLocalAuthorityService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            dismissed: {}
        )

        subject.start()
        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func cancelButton_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockCoordinator = MockBaseCoordinator()

        mockViewControllerBuilder._stubbedLocalAuthortiyPostcodeEntryViewController = expectedViewController
        var sut: EditLocalAuthorityCoordinator!
        let dismissed = await  withCheckedContinuation { continuation in
              sut = EditLocalAuthorityCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: MockAnalyticsService(),
                localAuthorityService: MockLocalAuthorityService(),
                coordinatorBuilder: mockCoordinatorBuilder,
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            mockCoordinator.start(sut)
            mockViewControllerBuilder._receivedLocalAuthorityDismissAction?()
        }
        
        #expect(dismissed)
        #expect(mockCoordinator._childDidFinishReceivedChild == sut)
        #expect(sut != nil)
        #expect(mockNavigationController._dismissCalled)
        #expect(mockNavigationController._receivedDismissAnimated == true)
    }

    @Test
    func dragToDismiss_callsDismissed() async {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockCoordinator = MockBaseCoordinator()
        mockViewControllerBuilder._stubbedLocalAuthortiyPostcodeEntryViewController = expectedViewController

        let dismissed = await withCheckedContinuation { continuation in
            let sut = EditLocalAuthorityCoordinator(
                navigationController: navigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                analyticsService: MockAnalyticsService(),
                localAuthorityService: MockLocalAuthorityService(),
                coordinatorBuilder: mockCoordinatorBuilder,
                dismissed: {
                    continuation.resume(returning: true)
                }
            )
            mockCoordinator.start(sut)
            sut.presentationControllerDidDismiss(sut.root.presentationController!)
        }
        #expect(dismissed)
    }

}
