import Foundation
import UIKit
import SwiftUI
import UIComponents
import Combine

class TopicOnboardingViewController: BaseViewController,
                                     TrackableScreen {
    var trackingName: String { "Select relevant topics" }
    private let viewModel: TopicOnboardingViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: TopicOnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private lazy var subtitleLabel: UILabel = {
        let localView = UILabel()
        localView.adjustsFontForContentSizeCategory = true
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.font = .govUK.body
        localView.text = viewModel.subtitle
        localView.textAlignment = .left
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        localView.textColor = .govUK.text.primary
        return localView
    }()

    private lazy var stackView: UIStackView = {
        let localView = UIStackView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .vertical
        localView.spacing = 16
        return localView
    }()

    private lazy var scrollView: UIScrollView = {
        let localView = UIScrollView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.showsVerticalScrollIndicator = false
        localView.contentInset.bottom = 32
        localView.contentInsetAdjustmentBehavior = .always
        return localView
    }()

    private lazy var topicsListView = TopicOnboardingListView(
        selectedAction: { [weak self] topic, selected in
            self?.viewModel.topicSelected(
                topic: topic,
                selected: selected
            )
        }
    )

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        registerObservers()
        addSubscriptions()
    }

    private func registerObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(topicsDidUpdate),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
    }

    @objc
    private func topicsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.topicsListView.updateTopics(self.viewModel.topics)
        }
    }

    private func configureUI() {
        title = viewModel.title
        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(footerView)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(topicsListView)
        topicsListView.updateTopics(viewModel.topics)
    }


    private lazy var footerView: UIView = {
        let localView = StickyFooterView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.addView(view: primaryButton)
        localView.addView(view: secondaryButton)
        return localView
    }()

    private lazy var primaryButton: UIButton = {
        let localView = GOVUKButton(
            .primary,
            viewModel: viewModel.primaryButtonViewModel
        )
        localView.isEnabled = viewModel.isTopicSelected
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private func addSubscriptions() {
        viewModel.$isTopicSelected.sink(
            receiveValue: primaryButton.setEnabled
        ).store(in: &cancellables)
    }

    private lazy var secondaryButton: UIView = {
        let localView = GOVUKButton(
            .secondary,
            viewModel: viewModel.secondaryButtonViewModel
        )
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
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
            footerView.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),
            footerView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            footerView.leftAnchor.constraint(
                equalTo: view.leftAnchor
            ),
            footerView.rightAnchor.constraint(
                equalTo: view.rightAnchor
            ),
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: footerView.topAnchor
            ),
            scrollView.leftAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leftAnchor
            ),
            scrollView.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor
            )
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        topicsListView.updateTopics(viewModel.topics)
    }
}
