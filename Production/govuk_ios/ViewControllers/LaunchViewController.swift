import UIKit
import Foundation

class LaunchViewController: BaseViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        activityIndicator.startAnimating()
    }

    private func configureUI() {
        view.backgroundColor = .link
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
    }

    private func configureConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
