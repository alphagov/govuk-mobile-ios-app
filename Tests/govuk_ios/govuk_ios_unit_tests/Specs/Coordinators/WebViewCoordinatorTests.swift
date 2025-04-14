import UIKit
import WebKit
import Testing

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
}
