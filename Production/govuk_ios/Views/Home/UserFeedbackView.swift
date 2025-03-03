import Foundation
import UIKit
import UIComponents
import GOVKit

final class UserFeedbackView: UIControl {
    private let viewModel: WidgetViewModel

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
        let image = UIImage(systemName: "chevron.forward")
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        let imageView = UIImageView(image: image)
        imageView.preferredSymbolConfiguration = config
        imageView.tintColor = UIColor.govUK.text.trailingIcon
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap))
    }()

    init(viewModel: WidgetViewModel) {
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
            stackView.topAnchor.constraint(
                equalTo: topAnchor, constant: 8
            ),
            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -8
            )
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
