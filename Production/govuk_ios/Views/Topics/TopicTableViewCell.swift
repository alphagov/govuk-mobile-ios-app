import UIKit
import Foundation

class TopicTableViewCell: UITableViewCell {
    private var topicCard: UIView = UIView()

    func configure(topic: Topic, viewModel: AllTopicsViewModel) {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.govUK.fills.surfaceBackground

        topicCard = TopicRowView(topic: topic)
        addSubview(topicCard)
        configureConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.topicCard.subviews.forEach({ $0.removeFromSuperview() })
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            topicCard.topAnchor.constraint(
                equalTo: topAnchor
            ),
            topicCard.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            topicCard.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            topicCard.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
            topicCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 72)
        ])
    }
}
