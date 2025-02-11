import Foundation
import UIKit

class TopicOnboardingListView: UIView {
    private let topics: [Topic]

    private var columnCount = 2

    private lazy var cardStackView: UIStackView = {
        let localView = UIStackView()
        localView.axis = .vertical
        localView.spacing = 16
        localView.distribution = .fill
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private var selectedAction: (Topic) -> Void

    init(topics: [Topic],
         selectedAction: @escaping (Topic) -> Void) {
        self.topics = topics
        self.selectedAction = selectedAction
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(cardStackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),
            cardStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            ),
            cardStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            cardStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            )
        ])
    }

    func updateTopics() {
        cardStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<topics.count where index % columnCount == 0 {
            let rowStack = createRow(startingAt: index, of: topics)
            cardStackView.addArrangedSubview(rowStack)
        }
    }

    private func createRow(startingAt startIndex: Int,
                           of topics: [Topic]) -> UIStackView {
        let rowStack = createRowStack()
        for index in startIndex..<(startIndex + columnCount) {
            let view = index <= topics.count - 1 ?
            createOnboardingTopicCard(for: topics[index]) :
            UIView()
            rowStack.addArrangedSubview(view)
        }
        return rowStack
    }

    private func createRowStack() -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 16
        rowStack.distribution = .fillEqually
        return rowStack
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setColumnCount()
        updateTopics()
    }

    private func setColumnCount() {
        layoutIfNeeded()

        if UITraitCollection.current.verticalSizeClass == .regular {
            columnCount = shouldReduceColumnCount ? 1 : 2
        } else {
            columnCount = shouldReduceColumnCount ? 2 : 4
        }
    }

    private var shouldReduceColumnCount: Bool {
        UITraitCollection.current.preferredContentSizeCategory.numericValue > 5
    }

    private func createOnboardingTopicCard(for topic: Topic) -> TopicOnboardingCard {
        let model = TopicOnboardingCardModel(
            topic: topic,
            selectedAction: selectedAction
        )
        return TopicOnboardingCard(
            viewModel: model, displayCompactCard: shouldReduceColumnCount
        )
    }
}
