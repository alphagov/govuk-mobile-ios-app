import UIKit
import Foundation

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func configureUI() {
        view.layoutMargins.right = 16
        view.layoutMargins.left = 16
    }
}
