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

//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        self.tabBarController?.tabBar.layer.shadowColor = UIColor.primaryDivider.cgColor
//    }
}
