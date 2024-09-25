import Foundation
import UIKit

class RecentActivtyWidget: UIControl {
    private let viewModel: WidgetViewModel

    init(viewModel: WidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
        configureAccessibility()
    }

    private func configureAccessibility() {
        self.accessibilityLabel = String.home.localized(
            "recentActivityWidgetAccessibilityLabel"
        )
        self.accessibilityTraits = .button
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
        stackView.addArrangedSubview(recentActivitesIcon)
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(70.0, after: titleLabel)
        stackView.addArrangedSubview(chevronImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.bodySemibold
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.text = viewModel.title
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var recentActivitesIcon: UIImageView = {
        let image = UIImage(named: "recent_activity_widget_icon")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    private lazy var chevronImage: UIImageView = {
        let image = UIImage(named: "recent_activity_cell_chevron")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubview(stackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor)
        ])
    }

    @objc
    private func recentActivityButtonPressed() {
        viewModel.primaryAction?()
    }
}
