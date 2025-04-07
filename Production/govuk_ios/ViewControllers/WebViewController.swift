import UIKit
import WebKit

final class WebViewController: UIViewController,
                               WKUIDelegate,
                               WKNavigationDelegate {
    let viewModel: WebViewModel

    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WebView", bundle: .main)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.didAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewModel.rightBarButtonTitle != nil {
            self.navigationItem.rightBarButtonItem = .init(
                title: viewModel.rightBarButtonTitle,
                style: .done,
                target: self,
                action: #selector(dismissScreen)
            )
        }

        Task {
            await loadWeb(url: viewModel.url)
        }
    }

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.text = viewModel.title
            titleLabel.font = UIFont.govUK.title1
            titleLabel.accessibilityTraits = .header
            titleLabel.accessibilityIdentifier = "titleLabel"
        }
    }

    @IBOutlet private var webView: WKWebView! {
        didSet {
            webView.accessibilityIdentifier = "webView"
        }
    }

    @objc private func dismissScreen() {
        self.dismiss(animated: true)
        viewModel.didDismiss()
    }

    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
           frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor
                 navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
//        if let url = navigationAction.request.url {
//            if url.scheme == "mailto" {
//                urlOpener.open(url: url)
//                return .cancel
//            } else if url.host == viewModel.url.host {
//                return .allow
//            } else if url.host?.contains(".gov.uk") == true {
//                return .allow
//            } else {
//                urlOpener.open(url: url)
//                return .cancel
//            }
//        }
        return .allow
    }

    func loadWeb(url: URL) async {
        let request = URLRequest(url: url)

        if let path = Bundle.main.path(forResource: viewModel.javascript, ofType: "js") {
            do {
                let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                let script = WKUserScript(
                    source: string,
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: false
                )
                webView.configuration.userContentController.addUserScript(script)
                print(webView.configuration.userContentController.userScripts.count)
            } catch {
                print("ah something went wrong")
            }
        }

        webView.load(request)
    }

    func webBack() {
        if webView.goBack() != nil {
            webView.goBack()
        } else {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true

            guard navigationController?.viewControllers.count ?? 0 > 0 else { return }

            let webViewVCIndex = navigationController?.viewControllers.firstIndex {
                $0 is WebViewController
            } as? Int

            guard let webViewVCIndex else { return }

            if let viewController = navigationController?.viewControllers[webViewVCIndex - 1] {
                navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
}
