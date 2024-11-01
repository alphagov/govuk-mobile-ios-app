import Foundation
import UIKit

class TopicRowView: UIView {
    private let topic: Topic

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.bodySemibold
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = topic.title
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var icon: UIImageView = {
        let image = UIImage(systemName: topic.iconName)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.govUK.fills.surfaceButtonPrimary
        imageView.preferredSymbolConfiguration = config
        imageView.contentMode = .center
        return imageView
    }()

    private lazy var chevronImage: UIImageView = {
        let image = UIImage(systemName: "chevron.forward")
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let imageView = UIImageView(image: image)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = UIColor.govUK.strokes.listDivider
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .right
        return imageView
    }()

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(topic: Topic) {
        self.topic = topic
        super.init(frame: .zero)

        configureUI()
        configureConstraints()
        configureAccessibility()
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.fills.surfaceCard
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.govUK.strokes.listDivider.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        cardStackView.addArrangedSubview(icon)
        cardStackView.addArrangedSubview(titleLabel)
        cardStackView.addArrangedSubview(chevronImage)
        addSubview(cardStackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(greaterThanOrEqualToConstant: 35),

            cardStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 16),
            cardStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16),
            cardStackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor,
                constant: 8),
            cardStackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor,
                constant: -8)
        ])
    }

    private func configureAccessibility() {
        self.isAccessibilityElement = true
        self.accessibilityTraits = .button
        self.accessibilityLabel = topic.title
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
