import Foundation
import Testing
import WebKit
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct WebViewControllerTests {

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
