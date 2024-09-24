import Foundation
import UIKit

class RecentActivtyWidgetStackView: UIStackView {
    private let viewModel: WidgetViewModel

    init(viewModel: WidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
        self.addGestureRecognizer(gesture)
    }

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.bodySemibold
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.accessibilityLabel = String.home.localized(
            "recentActivityWidgetAccessibilityLabel"
        )
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var icon: UIImageView = {
        let image = UIImage(named: "recent_activity_widget_icon")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    private lazy var recentActivityButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "recent_activity_cell_chevron")
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(recentActivityButtonPressed),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var gesture: UIGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(recentActivityButtonPressed)
        )
        return recognizer
    }()

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        spacing = 16
        axis = .horizontal
        addArrangedSubview(icon)
        addArrangedSubview(titleLabel)
        setCustomSpacing(70.0, after: titleLabel)
        addArrangedSubview(recentActivityButton)
        titleLabel.text = viewModel.title
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            recentActivityButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }

    @objc
    private func recentActivityButtonPressed() {
        viewModel.primaryAction?()
    }
}
