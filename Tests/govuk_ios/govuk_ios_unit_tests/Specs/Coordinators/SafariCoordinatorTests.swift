import UIKit
import Foundation
import Testing
import SafariServices

@testable import govuk_ios

@Suite
struct SafariCoordinatorTests {
    @Test
    @MainActor
    func start_presentsSafariViewController() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSafariViewController = expectedViewController
        let mockNavigationController = MockNavigationController()
        let subject = SafariCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            url: .arrange
        )
        subject.start()

        let navigationController = mockNavigationController._presentedViewController as? UINavigationController
        let unwrappedNavigationController = try #require(navigationController)
        #expect(unwrappedNavigationController.topViewController === expectedViewController)
    }

    @Test
    @MainActor
    func start_showExpectedURL() throws {
        let expectedURL = URL.arrange
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let subject = SafariCoordinator(
            navigationController: MockNavigationController(),
            viewControllerBuilder: mockViewControllerBuilder,
            url: expectedURL
        )
        subject.start()

        #expect(mockViewControllerBuilder._receivedSafariUrl == expectedURL)
    }
}
