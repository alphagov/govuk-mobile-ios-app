import Foundation
import UIKit

class TopicOnboardingCard: UIControl {
    private let viewModel: TopicOnboardingCardModel

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let image = UIImage(systemName: viewModel.iconName)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.govUK.text.link
        imageView.preferredSymbolConfiguration = config
        return imageView
    }()

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

    private lazy var selectedStackView: TopicSelectedView = {
        let localView = TopicSelectedView()
        localView.isSelected = viewModel.isSelected
        return localView
    }()

    init(viewModel: TopicOnboardingCardModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        addActions()
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
        cardStackView.addArrangedSubview(iconImageView)
        cardStackView.addArrangedSubview(titleLabel)
        cardStackView.addArrangedSubview(descriptionLabel)

        let spacer = UIView()
        cardStackView.addArrangedSubview(spacer)
        cardStackView.setCustomSpacing(0, after: spacer)

        cardStackView.addArrangedSubview(selectedStackView)
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
        toggleTintColorOfCard()
        selectedStackView.isSelected = viewModel.isSelected
        configureAccessibility()
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
        backgroundColor = viewModel.isSelected ?
        UIColor.govUK.fills.surfaceCardSelected :
        UIColor.govUK.fills.surfaceCard
    }
}
