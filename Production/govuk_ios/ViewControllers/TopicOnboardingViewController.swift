import Foundation
import UIKit
import SwiftUI
import UIComponents

class TopicOnboardingViewController: BaseViewController {
    let viewModel: TopicOnboardingViewModel
    private let backgroundColor = UIColor.govUK.fills.surfaceBackground

    init(viewModel: TopicOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = backgroundColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.text = String.topics.localized(
            "topicsOnboardingTitlelabel"
        )
        localView.textAlignment = .left
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.textColor = UIColor.govUK.text.primary
        return localView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset.bottom = 32
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        title = viewModel.navigationTitle
    }

    private func configureUI() {
        view.addSubview(scrollView)
        view.addSubview(buttonView)
        addWidgets()
    }

    private func addWidgets() {
        viewModel.widgets.lazy.forEach(stackView.addArrangedSubview)
    }

    private lazy var buttonView: UIView =  {
        let buttonView = UIHostingController(
            rootView: TopicsButtonView(viewModel: self.viewModel)
        ).view

        guard let buttonView = buttonView else {
            return UIView()
        }
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        return buttonView
    }()

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),

            buttonView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            buttonView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonView.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])
    }
}

extension TopicOnboardingViewController: TrackableScreen {
    var trackingName: String {
        "Select relevant topics"
    }
}
