import Foundation
import UIKit

class RecentActivtyWidget: UIControl {
    private let viewModel: RecentActivityWidgetViewModel

    init(viewModel: RecentActivityWidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        configureAccessibility()
    }

    private func configureAccessibility() {
        accessibilityLabel = String.home.localized(
            "recentActivityWidgetAccessibilityLabel"
        )
        accessibilityTraits = .button
    }

    private lazy var gesture: UIGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(recentActivityButtonPressed)
        )
        return recognizer
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.bodySemibold
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.title
        localView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var recentActivitesIcon: UIImageView = {
        let image = UIImage(named: "recent_activity_widget_icon")
        let imageView = UIImageView(image: image)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var chevronImage: UIImageView = {
        let image = UIImage(systemName: "chevron.forward")
        let imageView = UIImageView(image: image)
        let config = UIImage.SymbolConfiguration(pointSize: 12)
        imageView.tintColor = UIColor.govUK.text.trailingIcon
        imageView.preferredSymbolConfiguration = config
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(stackView)

        stackView.addArrangedSubview(recentActivitesIcon)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(chevronImage)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    @objc
    private func recentActivityButtonPressed() {
        viewModel.action()
    }
}
