import UIKit
import WebKit
import Testing
import Foundation

@testable import govuk_ios

@Suite
@MainActor
struct WebViewCoordinatorTests {

    @Test
    func init_setsExpectedProperties() {
        let mockNavigationController = MockNavigationController()
        let viewControllerBuilder = ViewControllerBuilder()
        let testURL = URL(string: "https://www.gov.uk")!
        
        let coordinator = WebViewCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: viewControllerBuilder,
            url: testURL
        )
        
        #expect(coordinator.root == mockNavigationController)
    }
    
    @Test
    func start_setsWebViewControllerAsRoot() {
        let mockNavigationController = MockNavigationController()
        let viewControllerBuilder = ViewControllerBuilder()
        let testURL = URL(string: "https://www.gov.uk")!
        
        let coordinator = WebViewCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: viewControllerBuilder,
            url: testURL
        )
        
        coordinator.start(url: nil)
        
        #expect(mockNavigationController.viewControllers.count == 1)
        #expect(mockNavigationController.viewControllers.first is WebViewController)
    }
    
    @Test
    func start_ignoresProvidedURL() {
        let mockNavigationController = MockNavigationController()
        let viewControllerBuilder = ViewControllerBuilder()
        let testURL = URL(string: "https://www.gov.uk")!
        let differentURL = URL(string: "https://different.gov.uk")!
        
        let coordinator = WebViewCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: viewControllerBuilder,
            url: testURL
        )
        
        coordinator.start(url: differentURL)
        
        let webViewController = mockNavigationController.viewControllers.first as? WebViewController
        #expect(webViewController != nil)
    }
}
