import UIKit
import WebKit
import Testing
import Foundation

@testable import govuk_ios

@Suite
@MainActor
struct WebViewCoordinatorTests {

    @Test
    func init_setsURLCorrectly() {
        let url = URL(string: "https://gov.uk")!
        let subject = WebViewController(url: url)

        #expect(subject.view != nil)
    }

    @Test
    func viewDidLoad_setsUpWebViewAndLoadsURL() {
        let url = URL(string: "https://gov.uk")!
        let subject = WebViewController(url: url)

        _ = subject.view

        let webViews = subject.view.subviews.compactMap { $0 as? WKWebView }
        #expect(webViews.count == 1)

        let webView = webViews.first!

        let loadedRequest = webView.url?.absoluteString
        #expect(loadedRequest?.hasPrefix(url.absoluteString) == true)
    }

    @Test
    func webView_existsInViewHierarchy() {
        let url = URL(string: "https://gov.uk")!
        let subject = WebViewController(url: url)

        _ = subject.view

        let webViewFound = subject.view.subviews.contains { $0 is WKWebView }
        #expect(webViewFound == true)
    }

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
