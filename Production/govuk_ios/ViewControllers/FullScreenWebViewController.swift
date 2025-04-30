import UIKit
import WebKit

class FullScreenWebViewController: UIViewController {
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "WebView Test"
        setupWebView()
        setupCloseButton()
        loadContent()
    }

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }

    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done,
                                          target: self, action: #selector(dismissWebView))
        navigationItem.rightBarButtonItem = closeButton
    }

    private func loadContent() {
        let htmlString = """
        <p>Sign in to your Universal Credit account to:</p>

        <ul>
          <li>apply for an advance on your first payment</li>
          <li>see your statement</li>
          <li>report a change in circumstances</li>
          <li>add a note to your journal</li>
          <li>see your to-do list</li>
          <li>see when your next payment will be</li>
          <li>see your Claimant Commitment</li>
        </ul>

        <p>Use the username and password you set up when you applied for
        Universal Credit. You can ask for a reminder if you're not sure.
        </p>

        <div role="note" aria-label="Information" class="application-notice info-notice">
            <p>This service is also available
                <a href="/mewngofnodi-ich-cyfrif-credyd-cynhwysol">in Welsh (Cymraeg)</a>.
            </p>
        </div>
        """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    @objc private func dismissWebView() {
        dismiss(animated: true, completion: nil)
    }
}
