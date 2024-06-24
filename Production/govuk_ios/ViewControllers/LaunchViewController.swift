import UIKit
import Foundation

import Lottie

class LaunchViewController: BaseViewController {
    private lazy var animationView = LottieAnimationView(name: "app_splash")

    private let viewModel: LaunchViewModel

    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        guard UIView.areAnimationsEnabled
        else { return viewModel.animationCompleted() }
        animationView.play(
            completion: { [weak self] finished in
                guard finished else { return }
                self?.viewModel.animationCompleted()
            }
        )
    }

    private func configureUI() {
        view.backgroundColor = .splashScreenBlue
        view.addSubview(animationView)
    }

    private func configureConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.rightAnchor.constraint(
            equalTo: view.layoutMarginsGuide.rightAnchor,
            constant: -20
        ).isActive = true
        animationView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 20).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
