import Foundation
import UIKit
import UIComponents

final class UserFeedbackView: UIControl {
    private let viewModel: UserFeedbackViewModel

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.govUK.bodySemibold
        label.textColor = UIColor.govUK.text.primary
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let titleImageView: UIImageView = {
        let image = UIImage(named: "recent_activity_cell_chevron")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }()

    init(viewModel: UserFeedbackViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        titleLabel.text = viewModel.title
        configureUI()
        configureConstraints()
        configureAccessibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleImageView)
        addSubview(stackView)
        addGestureRecognizer(gestureRecognizer)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 12)
        ])
    }

    private func configureAccessibility() {
        accessibilityTraits = .link
        accessibilityLabel = viewModel.title
        accessibilityHint = String.common.localized("openWebLinkHint")
    }

    @objc
    private func handleTap() {
        viewModel.action()
    }
}
