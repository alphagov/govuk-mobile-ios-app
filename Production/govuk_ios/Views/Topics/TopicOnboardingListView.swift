import Foundation
import UIKit

class TopicOnboardingListView: UIView {
    private var rowCount: Int {
        UITraitCollection.current.verticalSizeClass == .regular ? 2 : 4
    }

    private lazy var cardStackView: UIStackView = {
        let localView = UIStackView()
        localView.axis = .vertical
        localView.spacing = 16
        localView.distribution = .fill
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private var selectedAction: (Topic) -> Void

    init(selectedAction: @escaping (Topic) -> Void) {
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
        cardStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<topics.count where index % rowCount == 0 {
            let rowStack = createRow(startingAt: index, of: topics)
            cardStackView.addArrangedSubview(rowStack)
        }
    }

    private func createRow(startingAt startIndex: Int,
                           of topics: [Topic]) -> UIStackView {
        let rowStack = createRowStack()
        for index in startIndex..<(startIndex + rowCount) {
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

    private func createOnboardingTopicCard(for topic: Topic) -> TopicOnboardingCard {
        let model = TopicOnboardingCardModel(
            topic: topic,
            selectedAction: selectedAction
        )
        return TopicOnboardingCard(viewModel: model)
    }
}
