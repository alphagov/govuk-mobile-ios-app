import UIKit
import Foundation
import Testing
import SafariServices

@testable import govuk_ios
@testable import GOVKitTestUtilities

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
            presentingViewController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            configService: MockAppConfigService(),
            urlOpener: MockURLOpener(),
            url: .arrange,
            fullScreen: false
        )
        subject.start()

        let navigationController = mockNavigationController._presentedViewController as? UINavigationController
        let unwrappedNavigationController = try #require(navigationController)
        #expect(unwrappedNavigationController.topViewController === expectedViewController)
    }

    @Test
    @MainActor
    func start_externalBrowserDisabled_presentsSafariViewController() throws {
        let expectedURL = URL.arrange
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let subject = SafariCoordinator(
            presentingViewController: MockNavigationController(),
            viewControllerBuilder: mockViewControllerBuilder,
            configService: MockAppConfigService(),
            urlOpener: MockURLOpener(),
            url: expectedURL,
            fullScreen: true
        )
        subject.start()

        #expect(mockViewControllerBuilder._receivedSafariUrl == expectedURL)
    }

    @Test
    @MainActor
    func start_externalBrowserEnabled_opensURL() throws {
        let expectedURL = URL.arrange
        let mockConfigService = MockAppConfigService()
        mockConfigService.features = [.externalBrowser]
        let mockURLOpener = MockURLOpener()
        let subject = SafariCoordinator(
            presentingViewController: MockNavigationController(),
            viewControllerBuilder: MockViewControllerBuilder(),
            configService: mockConfigService,
            urlOpener: mockURLOpener,
            url: expectedURL,
            fullScreen: false
        )
        subject.start()

        #expect(mockURLOpener._receivedOpenIfPossibleUrl == expectedURL)
    }
}
