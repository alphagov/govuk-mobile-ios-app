import Foundation
import UIKit

class TopicOnboardingCard: UIView {
    private let viewModel: TopicOnboardingCardModel

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.bodySemibold
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.title
        localView.textAlignment = .center
        localView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var selectedLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.body
        localView.text = String.topics.localized(
            "topicOnboardingCardUnselected"
        )
        localView.textAlignment = .center
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        return localView
    }()

    private lazy var selectedIconImageView: UIImageView = {
        let icon = UIImage(systemName: "plus")
        let imageView = UIImageView(image: icon)
        return imageView
    }()

    private lazy var selectedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.body
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.description
        localView.textAlignment = .center
        localView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: viewModel.iconName)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.govUK.text.link
        imageView.preferredSymbolConfiguration = config
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(viewModel: TopicOnboardingCardModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        configureGestures()
        configureAccessibility()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.fills.surfaceCard
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.govUK.strokes.listDivider.cgColor
        addSubview(cardStackView)
        selectedStackView.addArrangedSubview(selectedIconImageView)
        selectedStackView.addArrangedSubview(selectedLabel)
        cardStackView.addArrangedSubview(iconImageView)
        cardStackView.addArrangedSubview(titleLabel)
        cardStackView.addArrangedSubview(descriptionLabel)
        cardStackView.addArrangedSubview(selectedStackView)
        toggleSelectedIconAndTextViews()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            cardStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            cardStackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor,
                constant: 8
            ),
            cardStackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor,
                constant: -8
            )
        ])
    }

    private func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(cardTapped)
        )
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        accessibilityLabel = viewModel.title
    }

    @objc
    private func cardTapped() {
        viewModel.isSelected.toggle()
        toggleTintColorOfCard()
        toggleSelectedIconAndTextViews()
        viewModel.tapAction(
            viewModel.isSelected
        )
    }

    private func toggleSelectedIconAndTextViews() {
        selectedLabel.text = viewModel.isSelected ?
        String.topics.localized("topicOnboardingCardSelected") :
        String.topics.localized("topicOnboardingCardUnselected")

        selectedLabel.textColor = viewModel.isSelected ?
        UIColor.govUK.text.buttonSuccess :
        UIColor.govUK.text.link

        selectedIconImageView.tintColor = viewModel.isSelected ?
        UIColor.govUK.text.buttonSuccess :
        UIColor.govUK.fills.surfaceButtonPrimary
    }

    private func toggleTintColorOfCard() {
        backgroundColor = viewModel.isSelected ?
        UIColor.govUK.fills.surfaceCardSelected :
        UIColor.govUK.fills.surfaceCard
    }
}
