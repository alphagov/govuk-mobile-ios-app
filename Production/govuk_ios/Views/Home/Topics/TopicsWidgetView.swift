import UIKit

class TopicsWidgetView: UIView {
    var topicCards = [TopicCard]()
    var topics = [Topic]() {
        didSet {
            topics.append(topics[1])
            topics.append(topics[0])
            topics.append(topics[0])
            updateTopics()
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.title3Semibold
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.text = String.home.localized("topicsWidgetTitle")
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    private func configureUI() {
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func updateTopics() {
        for index in 0..<topics.count where index % 2 == 0 {
            let rowStack = createNewRow(startingAt: index)
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(rowStack)
            rowStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
            rowStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        }
    }

    private func createNewRow(startingAt index: Int) -> UIStackView {
        let rowStack = createRowStack()
        let firstCard = createTopicCard(for: topics[index])
        rowStack.addArrangedSubview(firstCard)

        if index + 1 <= topics.count - 1 {
            let secondCard = createTopicCard(for: topics[index + 1])
            rowStack.addArrangedSubview(secondCard)
            firstCard.heightAnchor.constraint(equalTo: secondCard.heightAnchor).isActive = true
        } else {
            rowStack.addArrangedSubview(UIView())
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
        let viewModel = TopicCardModel(topic: topic)
        let topicCard = TopicCard(viewModel: viewModel)
        topicCard.translatesAutoresizingMaskIntoConstraints = false
        return topicCard
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
