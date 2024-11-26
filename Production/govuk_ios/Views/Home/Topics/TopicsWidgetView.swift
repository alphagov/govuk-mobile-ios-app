import UIKit
import UIComponents

class TopicsWidgetView: UIView {
    let viewModel: TopicsWidgetViewModel

    private var rowCount = 2
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
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.text = viewModel.widgetTitle
        return label
    }()

    private lazy var editButton: UIButton = .body(
        title: String.common.localized("editButtonTitle"),
        accessibilityLabel: String.topics.localized("editTopicsTitle"),
        action: viewModel.editAction
    )

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .bottom
        stackView.distribution = .fill
        return stackView
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
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

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
        updateTopics(viewModel.displayedTopics)
        showAllTopicsButton()
    }

    @objc
    private func topicsDidUpdate(notification: Notification) {
        DispatchQueue.main.async {
            self.updateTopics(self.viewModel.displayedTopics)
            self.showAllTopicsButton()
            self.titleLabel.text = self.viewModel.widgetTitle
        }
    }

    private func configureUI() {
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(editButton)
        headerStackView.accessibilityElements = [titleLabel, editButton]
        stackView.addArrangedSubview(headerStackView)
        stackView.addArrangedSubview(cardStackView)
        stackView.addArrangedSubview(allTopicsButton)
        addSubview(stackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
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
        cardStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<topics.count where index % rowCount == 0 {
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

        for index in (startIndex + 1)..<(startIndex + rowCount) {
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
        let sizeClass = UITraitCollection.current.verticalSizeClass
        if sizeClass != previousTraitCollection?.verticalSizeClass {
            rowCount = sizeClass == .regular ? 2 : 4
            updateTopics(viewModel.displayedTopics)
        }

        // At largest size, will truncate titleLabel text so edit button remains visible
        // At smaller sizes, ensures edit button remains right-aligned
        if UITraitCollection.current.preferredContentSizeCategory
            == .accessibilityExtraExtraExtraLarge {
            titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        } else {
            titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
    }

    private func showAllTopicsButton() {
        allTopicsButton.isHidden = viewModel.allTopicsButtonHidden
    }
}
