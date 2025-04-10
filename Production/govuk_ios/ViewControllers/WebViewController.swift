import UIKit
import WebKit

class WebViewController: UIViewController {
    private let url: URL
    private var webView: WKWebView!

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }

    private func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
    }

    private func loadURL() {
        webView.load(URLRequest(url: url))
    }
}
