import UIKit

class TopicCard: UIView {
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

    private lazy var icon: UIImageView = {
        let imageView = UIImageView(image: viewModel.icon)
        imageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.govUK.text.trailingIcon
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()

    private lazy var chevronImage: UIImageView = {
        let image = UIImage(systemName: "chevron.forward")
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let imageView = UIImageView(image: image)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = UIColor.govUK.text.trailingIcon
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 9).isActive = true
        return imageView
    }()

    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .bottom
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
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
        backgroundColor = UIColor.govUK.fills.surfaceCardBlue
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.govUK.strokes.cardBlue.cgColor
        addSubview(cardStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(chevronImage)
        cardStackView.addArrangedSubview(icon)
        cardStackView.addArrangedSubview(titleStackView)
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
                constant: -8),
            titleStackView.leadingAnchor.constraint(
                equalTo: cardStackView.leadingAnchor,
                constant: 0),
            titleStackView.trailingAnchor.constraint(
                equalTo: cardStackView.trailingAnchor,
                constant: 0)
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
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
