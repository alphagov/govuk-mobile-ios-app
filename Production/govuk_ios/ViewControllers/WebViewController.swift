import UIKit
import WebKit

class WebViewController: UIViewController {
    private let url: URL

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        loadContent()
    }

    private func configureUI() {
        view.addSubview(webView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadContent() {
        let targetURL = "https://www.gov.uk/sign-in-universal-credit"
        if url.absoluteString == targetURL {
            loadInjectedHTML()
        } else {
            webView.load(URLRequest(url: url))
        }
    }

    private func loadInjectedHTML() {
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
}
