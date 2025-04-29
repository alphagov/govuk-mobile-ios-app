import UIKit
import WebKit

class FullScreenWebViewController: UIViewController {
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        // Create WKWebView configuration
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)

        // Load Google.com as a test
        if let url = URL(string: "https://google.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    // Method to load HTML content
    func loadHTML(_ htmlString: String) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
