import Foundation
import UIKit
import SwiftUI
import UIComponents

class TopicOnboardingViewController: BaseViewController {
    private let viewModel: TopicOnboardingViewModel

    init(viewModel: TopicOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
    }

    private func configureUI() {
        view.addSubview(scrollView)
        view.addSubview(buttonView)
        addWidgets()
    }

    private func addWidgets() {
        stackView.addArrangedSubview(viewModel.topicsWidget)
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
            stackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),
            stackView.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor
            ),
            buttonView.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),
            buttonView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            buttonView.leftAnchor.constraint(
                equalTo: view.leftAnchor
            ),
            buttonView.rightAnchor.constraint(
                equalTo: view.rightAnchor
            ),
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: buttonView.topAnchor
            ),
            scrollView.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            ),
            scrollView.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor
            )
        ])
    }
}

extension TopicOnboardingViewController: TrackableScreen {
    var trackingName: String {
        "Select relevant topics"
    }
}
