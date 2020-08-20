import UIKit
import WebKit

class SettingsWebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard
            let url = URL(string: "https://caffeine.cr0ss.org/medical-information/")
        else { return }

        webView?.load(.init(url: url))
    }
}
