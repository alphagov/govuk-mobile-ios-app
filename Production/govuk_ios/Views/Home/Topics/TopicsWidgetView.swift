import UIKit
import SwiftUI
import UIComponents
import GOVKit

// swiftlint:disable:next type_body_length
class TopicsWidgetView: UIView {
    let viewModel: TopicsWidgetViewModel

    private var columnCount = 2
    private lazy var allTopicsButton: GOVUKButton = {
        var buttonViewModel: GOVUKButton.ButtonViewModel {
            .init(
                localisedTitle: String.topics.localized("seeAllTopicsButtonText"),
                action: { [weak self] in
                    self?.viewModel.allTopicsAction()
                }
            )
        }
        let button = GOVUKButton(.compact, viewModel: buttonViewModel)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)

        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.title3Semibold
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.text = viewModel.widgetTitle
        label.accessibilityTraits = .header
        return label
    }()

    private lazy var editButton: GOVUKButton = {
        var viewModel: GOVUKButton.ButtonViewModel {
            .init(
                localisedTitle: String.common.localized("editButtonTitle"),
                action: {[weak self] in
                    self?.viewModel.editAction()
                }
            )
        }
        let button = GOVUKButton(
            .secondary,
            viewModel: viewModel
        )
        button.accessibilityLabel = String.home.localized("topicsWidgetEditButtonTitle")
        button.titleLabel?.font = UIFont.govUK.subheadlineSemibold
        return button
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var noTopicsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.govUK.text.primary
        label.font = UIFont.govUK.body
        label.text = String.home.localized("noTopicsDescriptionText")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var appErrorViewController: UIViewController = {
        let localController = HostingViewController(
            rootView: AppErrorView(
                viewModel: self.viewModel.topicErrorViewModel
            )
        )
        localController.view.backgroundColor = .clear
        localController.view.isHidden = true
        localController.shouldAutoFocusVoiceover = false
        return localController
    }()

    private var errorView: UIView {
        appErrorViewController.view
    }

    init(viewModel: TopicsWidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(topicsDidUpdate),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
        fetchTopics()
        updateTopics(viewModel.displayedTopics)
        showAllTopicsButton()
    }

    @objc
    private func topicsDidUpdate(notification: Notification) {
        DispatchQueue.main.async {
            self.updateTopics(self.viewModel.displayedTopics)
            if !self.viewModel.initialLoadComplete {
                self.viewModel.initialLoadComplete = true
                self.viewModel.trackECommerce()
            }
            self.showAllTopicsButton()
            self.titleLabel.text = self.viewModel.widgetTitle
        }
    }

    private func fetchTopics() {
        viewModel.handleError = { _ in
            self.noTopicsLabel.isHidden = true
            self.cardStackView.isHidden = true
            self.editButton.isHidden = true
            self.allTopicsButton.isHidden = true
            self.errorView.isHidden = false
        }
        viewModel.fetchTopics()
    }

    private func configureUI() {
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(UIView())
        headerStackView.addArrangedSubview(editButton)
        headerStackView.accessibilityElements = [titleLabel, editButton]
        stackView.addArrangedSubview(headerStackView)
        stackView.setCustomSpacing(8, after: headerStackView)
        stackView.addArrangedSubview(noTopicsLabel)
        stackView.addArrangedSubview(cardStackView)
        stackView.addArrangedSubview(allTopicsButton)
        stackView.addArrangedSubview(errorView)
        addSubview(stackView)
    }

    private func configureConstraints() {
        editButton.setContentHuggingPriority(.required, for: .horizontal)
        editButton.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            cardStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            cardStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    private func updateTopics(_ topics: [Topic]) {
        noTopicsLabel.isHidden = viewModel.fetchTopicsError || topics.count > 0
        cardStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<topics.count where index % columnCount == 0 {
            let rowStack = createNewRow(startingAt: index, of: topics)
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            cardStackView.addArrangedSubview(rowStack)
            rowStack.leadingAnchor.constraint(
                equalTo: cardStackView.leadingAnchor
            ).isActive = true
            rowStack.trailingAnchor.constraint(
                equalTo: cardStackView.trailingAnchor
            ).isActive = true
        }
    }

    private func createNewRow(startingAt startIndex: Int, of topics: [Topic]) -> UIStackView {
        let rowStack = createRowStack()
        let firstCard = createTopicCard(for: topics[startIndex])
        rowStack.addArrangedSubview(firstCard)

        for index in (startIndex + 1)..<(startIndex + columnCount) {
            if index <= topics.count - 1 {
                let card = createTopicCard(for: topics[index])
                rowStack.addArrangedSubview(card)
                firstCard.heightAnchor.constraint(equalTo: card.heightAnchor).isActive = true
            } else {
                rowStack.addArrangedSubview(UIView())
            }
        }
        return rowStack
    }

    private func createRowStack() -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 16
        rowStack.alignment = .top
        rowStack.distribution = .fillEqually
        return rowStack
    }

    private func createTopicCard(for topic: Topic) -> TopicCard {
        let topicCardModel = TopicCardModel(
            topic: topic,
            tapAction: { [weak self] in
                self?.viewModel.topicAction(topic)
                self?.viewModel.trackECommerceSelection(topic.title)
            }
        )
        let topicCard = TopicCard(viewModel: topicCardModel)
        topicCard.translatesAutoresizingMaskIntoConstraints = false
        return topicCard
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let contentSizeChanged = traitCollection.preferredContentSizeCategory !=
        previousTraitCollection?.preferredContentSizeCategory
        let sizeClassChanged = traitCollection.verticalSizeClass !=
        previousTraitCollection?.verticalSizeClass
        setColumnCount(viewModel.displayedTopics)
        if sizeClassChanged || contentSizeChanged {
            updateTopics(viewModel.displayedTopics)
        }

        errorView.invalidateIntrinsicContentSize()
    }

    private func setColumnCount(_ topics: [Topic]) {
        layoutIfNeeded()
        let sizeClass = UITraitCollection.current.verticalSizeClass
        let defaultColumnCount = sizeClass == .regular ? 2 : 4
        // Horizontal card space not available to title + spacing between cards
        let unavailableTitleCardWidth = (50 * defaultColumnCount) + (16 * (defaultColumnCount - 1))
        let availableTitleCardWidth = (bounds.width - CGFloat(unavailableTitleCardWidth)) /
        CGFloat(defaultColumnCount)
        let reduceColumnCount = shouldReduceColumnCount(
            for: availableTitleCardWidth, topics: topics
        )

        if sizeClass == .regular {
            columnCount = reduceColumnCount ? 1 : 2
        } else {
            columnCount = reduceColumnCount ? 2 : 4
        }
    }

    private func shouldReduceColumnCount(for availableTitleCardWidth: CGFloat,
                                         topics: [Topic]) -> Bool {
        let longestWord = topics.flatMap {
            $0.title.components(separatedBy: .whitespacesAndNewlines)
        }.max { $0.count < $1.count } ?? ""
        let wordSize = (longestWord as NSString).size(
            withAttributes: [.font: UIFont.govUK.body]
        )
        if wordSize.width > availableTitleCardWidth {
            return true
        }
        return false
    }

    private func showAllTopicsButton() {
        allTopicsButton.isHidden = viewModel.allTopicsButtonHidden
    }
}
