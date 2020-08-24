import UIKit
import WebKit

class SettingsWebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView?
    var url: URL? {
        didSet {
            guard let url = self.url else { return }

            webView?.load(.init(url: url))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView?.navigationDelegate = self

        guard let url = self.url else { return }

        webView?.load(.init(url: url))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let url = self.url else { return }

        webView?.load(.init(url: url))
    }
}

extension SettingsWebViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else { return decisionHandler(.allow) }
            let webViewController = StoryboardScene.Settings.settingsWebViewController.instantiate()
            webViewController.url = url
            navigationController?.pushViewController(webViewController, animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

}
