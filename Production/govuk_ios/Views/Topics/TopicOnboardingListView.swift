import Foundation
import UIKit

class TopicOnboardingListView: UIView {
    private var rowCount = 2

    private lazy var cardStackView: UIStackView = {
        let localView = UIStackView()
        localView.axis = .vertical
        localView.spacing = 16
        localView.alignment = .leading
        localView.distribution = .fill
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private var selectedAction: (Topic, Bool) -> Void

    init(selectedAction: @escaping (Topic, Bool) -> Void) {
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

    func updateTopics(_ topics: [Topic]) {
        let sizeClass = UITraitCollection.current.verticalSizeClass
        rowCount = sizeClass == .regular ? 2 : 4
        cardStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<topics.count where index % rowCount == 0 {
            let rowStack = createRow(startingAt: index, of: topics)
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

    private func createRow(startingAt startIndex: Int,
                           of topics: [Topic]) -> UIStackView {
        let rowStack = createRowStack()
        let firstCard = createOnboardingTopicCard(for: topics[startIndex])
        rowStack.addArrangedSubview(firstCard)

        for index in (startIndex + 1)..<(startIndex + rowCount) {
            if index <= topics.count - 1 {
                let card = createOnboardingTopicCard(for: topics[index])
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
        rowStack.distribution = .fillEqually
        return rowStack
    }

    private func createOnboardingTopicCard(for topic: Topic) -> TopicOnboardingCard {
        let model = TopicOnboardingCardModel(
            topic: topic,
            tapAction: { [weak self] isSelected in
                self?.selectedAction(topic, isSelected)
            }
        )
        let topicCard = TopicOnboardingCard(viewModel: model)
        topicCard.translatesAutoresizingMaskIntoConstraints = false
        return topicCard
    }
}
