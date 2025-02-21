import Foundation
import UIKit

class TopicOnboardingCard: UIControl {
    let displayCompactCard: Bool

    private let viewModel: TopicOnboardingCardModel

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private lazy var mainContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = displayCompactCard ? .leading : .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.icon)
        imageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.govUK.text.trailingIcon
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.title3Semibold
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.title
        localView.textAlignment = displayCompactCard ? .left : .center
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var descriptionLabel: UILabel = {
        let localView = UILabel()
        localView.font = .govUK.subheadline
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.description
        localView.textAlignment = displayCompactCard ? .left : .center
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var selectedStackView: TopicSelectedView = {
        let localView = TopicSelectedView()
        localView.isSelected = viewModel.isSelected
        return localView
    }()

    init(viewModel: TopicOnboardingCardModel,
         displayCompactCard: Bool) {
        self.viewModel = viewModel
        self.displayCompactCard = displayCompactCard
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        configureAccessibility()
        configureSelectedState()
        addActions()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        layoutMargins = .init(all: 16)
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(cardStackView)

        if displayCompactCard {
            cardStackView.addArrangedSubview(iconImageView)
        } else {
            mainContentStackView.addArrangedSubview(iconImageView)
        }
        configureMainContentStackView()
    }

    private func configureSelectedState() {
        toggleTintColorOfCard()
        selectedStackView.isSelected = viewModel.isSelected
        configureAccessibility()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(
                equalTo: layoutMarginsGuide.topAnchor
            ),
            cardStackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            ),
            cardStackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
            ),
            cardStackView.bottomAnchor.constraint(
                equalTo: layoutMarginsGuide.bottomAnchor
            ),

            selectedStackView.bottomAnchor.constraint(
                equalTo: cardStackView.bottomAnchor
            )
        ])

        if displayCompactCard {
            configureCompactIconImageConstraints()
        }
    }

    private func configureCompactIconImageConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: 40
            ),
            iconImageView.widthAnchor.constraint(
                equalToConstant: 36
            )
        ])
    }

    private func addActions() {
        addTarget(
            self,
            action: #selector(cardTapped),
            for: .touchUpInside
        )
    }

    @objc
    private func cardTapped() {
        viewModel.selected()
        configureSelectedState()
    }

    private func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        if viewModel.isSelected {
            accessibilityTraits.insert(.selected)
        }
        accessibilityLabel = viewModel.title + ", " + (viewModel.description ?? "")
    }

    private func toggleTintColorOfCard() {
        if viewModel.isSelected {
            backgroundColor = UIColor.govUK.fills.surfaceCardSelected
            layer.borderColor = UIColor.govUK.strokes.cardSelected.cgColor
        } else {
            backgroundColor = UIColor.govUK.fills.surfaceCardBlue
            layer.borderColor = UIColor.govUK.strokes.cardBlue.cgColor
        }
    }

    private func configureMainContentStackView() {
        mainContentStackView.addArrangedSubview(titleLabel)
        mainContentStackView.addArrangedSubview(descriptionLabel)

        let spacer = UIView()
        mainContentStackView.addArrangedSubview(spacer)
        mainContentStackView.setCustomSpacing(0, after: spacer)

        mainContentStackView.addArrangedSubview(selectedStackView)

        cardStackView.addArrangedSubview(mainContentStackView)
    }
}
