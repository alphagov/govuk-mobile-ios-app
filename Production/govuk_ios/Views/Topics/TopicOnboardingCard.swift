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
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.body
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.description
        localView.textAlignment = .center
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: viewModel.iconName)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.govUK.text.link
        imageView.preferredSymbolConfiguration = config
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
        layoutMargins = .init(all: 16)
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
        let spacer = UIView()
        cardStackView.addArrangedSubview(spacer)
        cardStackView.setCustomSpacing(0, after: spacer)
        cardStackView.addArrangedSubview(selectedStackView)
        toggleSelectedIconAndTextViews()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(
                equalTo: layoutMarginsGuide.topAnchor
            ),
            cardStackView.bottomAnchor.constraint(
                equalTo: layoutMarginsGuide.bottomAnchor
            ),
            cardStackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            ),
            cardStackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
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
        if viewModel.isSelected {
            accessibilityTraits.insert(.selected)
        }
        accessibilityLabel = viewModel.title + ", " + (viewModel.description ?? "")
    }

    @objc
    private func cardTapped() {
        viewModel.isSelected.toggle()
        toggleTintColorOfCard()
        toggleSelectedIconAndTextViews()
        viewModel.tapAction(
            viewModel.isSelected
        )
        configureAccessibility()
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
