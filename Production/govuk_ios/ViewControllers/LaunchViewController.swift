import UIKit
import Foundation
import GOVKit

class LaunchViewController: BaseViewController {
    private let viewModel: LaunchViewModel
    private lazy var crownAnimationView = AnimationView.crownSplash
    private lazy var wordmarkAnimationView = AnimationView.wordmarkSplash
    private var crownPaddingConstraint: NSLayoutConstraint {
        crownAnimationView.topAnchor.constraint(
            equalTo: wordmarkAnimationView.bottomAnchor,
            constant: traitCollection.verticalSizeClass == .compact ? 25 : 150
        )
    }

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
        guard !wordmarkAnimationView.hasAnimationBegun else { return }
        wordmarkAnimationView.animateIfAvailable(
            completion: { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.viewModel.wordmarkAnimationCompleted = true
                    if self.viewModel.animationsCompleted {
                        self.viewModel.animationsCompletedAction()
                    }
                }
            }
        )
        guard !crownAnimationView.hasAnimationBegun else { return }
        crownAnimationView.animateIfAvailable(
            completion: { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.viewModel.crownAnimationCompleted = true
                    if self.viewModel.animationsCompleted {
                        self.viewModel.animationsCompletedAction()
                    }
                }
            }
        )
    }

    private func configureUI() {
        view.isAccessibilityElement = true
        view.accessibilityLabel = String.common.localized("splashScreenAccessibilityTitle")
        view.backgroundColor = .splashScreenBlue
        view.addSubview(wordmarkAnimationView)
        view.addSubview(crownAnimationView)
    }

    private func configureConstraints() {
        crownAnimationView.translatesAutoresizingMaskIntoConstraints = false
        wordmarkAnimationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            wordmarkAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordmarkAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wordmarkAnimationView.widthAnchor.constraint(equalToConstant: 244),
            wordmarkAnimationView.heightAnchor.constraint(equalToConstant: 84),

            crownAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crownAnimationView.widthAnchor.constraint(equalToConstant: 75),
            crownAnimationView.heightAnchor.constraint(equalToConstant: 75),
            crownPaddingConstraint,
            crownAnimationView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
}
