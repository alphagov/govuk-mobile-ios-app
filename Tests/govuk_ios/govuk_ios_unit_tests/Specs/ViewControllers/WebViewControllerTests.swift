import Foundation
import Testing
import WebKit
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct WebViewControllerTests {

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
    func viewDidLoad_setupsWebView() {
        let testURL = URL(string: "https://www.gov.uk")!
        let subject = WebViewController(url: testURL)
        
        subject.viewDidLoad()
        
        let webView = subject.view.subviews.first as? WKWebView

        let constraints = subject.view.constraints
        let hasTopConstraint = constraints.contains { constraint in
            constraint.firstAnchor == webView?.topAnchor &&
            constraint.secondAnchor == subject.view.topAnchor
        }
        let hasBottomConstraint = constraints.contains { constraint in
            constraint.firstAnchor == webView?.bottomAnchor &&
            constraint.secondAnchor == subject.view.bottomAnchor
        }
        let hasLeadingConstraint = constraints.contains { constraint in
            constraint.firstAnchor == webView?.leadingAnchor &&
            constraint.secondAnchor == subject.view.leadingAnchor
        }
        let hasTrailingConstraint = constraints.contains { constraint in
            constraint.firstAnchor == webView?.trailingAnchor &&
            constraint.secondAnchor == subject.view.trailingAnchor
        }

        #expect(webView != nil)
        #expect(hasTopConstraint)
        #expect(hasBottomConstraint)
        #expect(hasLeadingConstraint)
        #expect(hasTrailingConstraint)
    }
    
    @Test
    func viewDidLoad_loadsURL() {
        let testURL = URL(string: "https://www.gov.uk/")!
        let subject = WebViewController(url: testURL)
        subject.viewDidLoad()
        let webView = subject.view.subviews.first as? WKWebView

        #expect(webView?.url == testURL)
    }
} 
