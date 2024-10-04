import UIKit

class TopicsWidgetView: UIView {
    let viewModel: TopicsWidgetViewModel

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

    init(viewModel: TopicsWidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        viewModel.fetchTopics { result in
            switch result {
            case .success:
                self.updateTopics(viewModel.topics)
            case .failure:
                break
            }
        }
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

    private func updateTopics(_ topics: [Topic]) {
        for index in 0..<topics.count where index % 2 == 0 {
            let rowStack = createNewRow(startingAt: index, of: topics)
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(rowStack)
            rowStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
            rowStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        }
    }

    private func createNewRow(startingAt index: Int, of topics: [Topic]) -> UIStackView {
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
}