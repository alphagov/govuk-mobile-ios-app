import Foundation
import UIKit

class TopicOnboardingCard: UIView {
    private let viewModel: TopicOnboardingCardModel

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.bodySemibold
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = viewModel.title
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.text = String.topics.localized(
            "topicOnboardingCardUnselected"
        )
        label.textAlignment = .center
        label.textColor = UIColor.govUK.fills.surfaceButtonPrimary
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var selectedIcon: UIImageView = {
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
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = viewModel.description
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var icon: UIImageView = {
        let image = UIImage(systemName: viewModel.iconName)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.govUK.fills.surfaceButtonPrimary
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
        layer.borderColor = UIColor.secondaryBorder.cgColor
        addSubview(cardStackView)
        selectedStackView.addArrangedSubview(selectedIcon)
        selectedStackView.addArrangedSubview(selectedLabel)
        cardStackView.addArrangedSubview(icon)
        cardStackView.addArrangedSubview(titleLabel)
        cardStackView.addArrangedSubview(descriptionLabel)
        cardStackView.addArrangedSubview(selectedStackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
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

    private func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(cardTapped)
        )
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureAccessibility() {
        self.isAccessibilityElement = true
        self.accessibilityTraits = .button
        self.accessibilityLabel = viewModel.title
    }

    @objc
    private func cardTapped() {
        viewModel.isSelected.toggle()
        toggleTintColourOfCard()
        toggleSelectedIconAndTextViews()
        viewModel.tapAction(
            viewModel.isSelected
        )
    }

    private func toggleSelectedIconAndTextViews() {
        let selectedColourTint = ColorResource(
            name: "topicOnboardingSelectedTint",
            bundle: .main
        )
        selectedLabel.text = viewModel.isSelected ? String.topics.localized(
            "topicOnboardingCardSelected"
        ) : String.topics.localized(
            "topicOnboardingCardUnselected"
        )
        selectedLabel.textColor = viewModel.isSelected ? UIColor(
            resource: selectedColourTint
        ) : UIColor.govUK.fills.surfaceButtonPrimary

        selectedIcon.tintColor = viewModel.isSelected ? UIColor(
            resource: selectedColourTint
        ) : UIColor.govUK.fills.surfaceButtonPrimary
    }

    private func toggleTintColourOfCard() {
        configureColour()
    }

    private func configureColour() {
        switch viewModel.isSelected {
        case true:
            self.backgroundColor = UIColor(
                resource: ColorResource(
                    name: "topicOnboardingTint",
                    bundle: .main
                )
            )
        case false:
            self.backgroundColor = UIColor.govUK.fills.surfaceCard
        }
    }
}
