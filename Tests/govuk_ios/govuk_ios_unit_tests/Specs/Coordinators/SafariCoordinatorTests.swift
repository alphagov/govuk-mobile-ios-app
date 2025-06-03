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
        let mockConfigService = MockAppConfigService()
        mockConfigService.features = []
        let mockNavigationController = MockNavigationController()
        let subject = SafariCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            configService: mockConfigService,
            urlOpener: MockURLOpener(),
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
        let mockConfigService = MockAppConfigService()
        mockConfigService.features = []
        let subject = SafariCoordinator(
            navigationController: MockNavigationController(),
            viewControllerBuilder: mockViewControllerBuilder,
            configService: mockConfigService,
            urlOpener: MockURLOpener(),
            url: expectedURL
        )
        subject.start()

        #expect(mockViewControllerBuilder._receivedSafariUrl == expectedURL)
    }

    @Test
    @MainActor
    func start_openExpectedURL() throws {
        let expectedURL = URL.arrange
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockConfigService = MockAppConfigService()
        mockConfigService.features = [.externalBrowser]
        let mockURLOpener = MockURLOpener()
        let subject = SafariCoordinator(
            navigationController: MockNavigationController(),
            viewControllerBuilder: mockViewControllerBuilder,
            configService: mockConfigService,
            urlOpener: mockURLOpener,
            url: expectedURL
        )
        subject.start()

        #expect(mockURLOpener._receivedOpenIfPossibleUrl == expectedURL)
    }
}
