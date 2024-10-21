import UIKit
import Foundation

class TopicTableViewCell: UITableViewCell {
    var topicCard: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
