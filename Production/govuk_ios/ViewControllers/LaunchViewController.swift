import UIKit
import Foundation
import GOVKit

class LaunchViewController: BaseViewController {
    private lazy var animationView = AnimationView.launch

    private let viewModel: LaunchViewModel

    init(viewModel: LaunchViewModel,
         analyticsService: AnalyticsServiceInterface) {
        self.viewModel = viewModel
        super.init(analyticsService: analyticsService)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.animateIfAvailable(
            completion: { [weak self] in
                self?.viewModel.animationCompleted()
            }
        )
    }

    private func configureUI() {
        view.isAccessibilityElement = true
        view.accessibilityLabel = String.common.localized("splashScreenAccessibilityTitle")
        view.backgroundColor = .splashScreenBlue
        view.addSubview(animationView)
    }

    private func configureConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor
            ),
            animationView.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            ),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
