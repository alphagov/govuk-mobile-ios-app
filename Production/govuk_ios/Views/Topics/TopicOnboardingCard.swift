import Foundation
import UIKit

class TopicOnboardingCard: UIView {
    private let viewModel: TopicCardModel

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.bodySemibold
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = viewModel.title
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.text = "select"
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var selectIcon: UIImageView = {
        let icon = UIImage(systemName: "plus")
        let imageView = UIImageView(image: icon)
        return imageView
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

    private lazy var chevronImage: UIImageView = {
        let image = UIImage(systemName: "chevron.forward")
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let imageView = UIImageView(image: image)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = UIColor.govUK.strokes.listDivider
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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

    init(viewModel: TopicCardModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        configureGestures()
        configureAccessibility()
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.fills.surfaceCard
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.secondaryBorder.cgColor
        addSubview(cardStackView)
        cardStackView.addArrangedSubview(icon)
        cardStackView.addArrangedSubview(titleLabel)
        cardStackView.addArrangedSubview(descriptionLabel)
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
        viewModel.tapAction()
        viewModel.isSelected.toggle()
        toggleTintColout()
    }

    private func toggleTintColout() {
        if viewModel.isSelected {
            self.backgroundColor = UIColor(
                resource: ColorResource(
                    name: "topicOnboardingTint",
                    bundle: .main
                )
            )
        } else {
            self.backgroundColor = .white
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
