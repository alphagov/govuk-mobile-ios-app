//

import Foundation
import UIKit

class RecentActivtyWidgetStackView: UIStackView {
    private let viewModel: WidgetViewModel

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.bodySemibold
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var icon: UIImageView = {
        let image = UIKit.UIImage(named: "card-icon-set")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    private lazy var recentActivityButton: UIButton = {
        let button = UIButton()
        button.tintColor = .blue
        let image = UIKit.UIImage(named: "chevron")
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(recentActivityButtonPressed),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var buttonStackView = {
         var stackView = UIStackView()
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.axis = .horizontal
         return stackView
     }()

    init(viewModel: WidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

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
    }}
