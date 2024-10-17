import UIKit
import UIComponents

class TopicsWidgetView: UIView {
    let viewModel: TopicsWidgetViewModel

    private var rowCount = 2
    private lazy var allTopicsButton: GOVUKButton = {
        let buttonConfig = GOVUKButton.ButtonConfiguration(
            titleColorNormal: UIColor.govUK.text.buttonSecondary,
            titleColorHighlighted: UIColor.govUK.text.buttonSecondaryHighlight,
            titleColorFocused: UIColor.govUK.text.buttonSecondaryFocussed,
            titleFont: UIFont.govUK.body,
            backgroundColorNormal: UIColor.govUK.fills.surfaceCard,
            backgroundColorHighlighted: UIColor.govUK.fills.surfaceButtonSecondaryHighlight,
            backgroundColorFocused: UIColor.govUK.fills.surfaceButtonSecondaryFocussed,
            cornerRadius: 24,
            accessibilityButtonShapesColor: UIColor.govUK.fills.surfaceCard
        )
        var buttonViewModel: GOVUKButton.ButtonViewModel {
            .init(
                localisedTitle: String.topics.localized("seeAllTopicsButtonText"),
                action: { [weak self] in
                    self?.allTopicsButtonPressed()
                }
            )
        }
        let button = GOVUKButton(buttonConfig, viewModel: buttonViewModel)

        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.govUK.strokes.listDivider.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.title3Semibold
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.text = String.home.localized("topicsWidgetTitle")
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.common.localized("editButtonTitle"), for: .normal)
        button.titleLabel?.font = UIFont.govUK.bodySemibold
        button.addTarget(
            viewModel,
            action: #selector(viewModel.didTapEdit),
            for: .touchUpInside
        )
        button.tintColor = UIColor.govUK.text.link
        button.accessibilityLabel = String.topics.localized("editTopicsTitle")
        return button
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        updateTopics(viewModel.favoriteTopics)
        addAllTopicsButton()
    }

    @objc
    private func topicsDidUpdate(notification: Notification) {
        DispatchQueue.main.async {
            self.updateTopics(self.viewModel.favoriteTopics)
            self.addAllTopicsButton()
        }
    }

    private func configureUI() {
        //        titleLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(editButton)
        headerStackView.accessibilityElements = [titleLabel, editButton]
        stackView.addArrangedSubview(headerStackView)
        stackView.addArrangedSubview(cardStackView)
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
            stackView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cardStackView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: cardStackView.trailingAnchor)
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
        let topicCardModel = TopicCardModel(topic: topic) {
            self.viewModel.didTapTopic(topic)
        }
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
            updateTopics(viewModel.favoriteTopics)
        }
    }

    private func addAllTopicsButton() {
        guard viewModel.allTopicsDisplayed
        else { return stackView.addArrangedSubview(allTopicsButton) }
        stackView.removeArrangedSubview(allTopicsButton)
        allTopicsButton.removeFromSuperview()
    }

    @objc
    private func allTopicsButtonPressed() {
        viewModel.didTapSeeAllTopics()
    }
}
