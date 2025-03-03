import Foundation
import UIKit

public class GovUKHeaderView: UIView {
    public init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    public func configure(titleText: String) {
        titleLabel.text = titleText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .govUK.fills.surfaceHomeHeaderBackground
        titleContainerView.addSubview(titleLabel)
        addSubview(titleContainerView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            titleContainerView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            titleContainerView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            titleContainerView.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -8
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: titleContainerView.leadingAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: titleContainerView.trailingAnchor
            ),
            titleLabel.topAnchor.constraint(
                equalTo: titleContainerView.topAnchor
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: titleContainerView.bottomAnchor
            )
        ])
    }

    private let titleContainerView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private lazy var titleLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.adjustsFontForContentSizeCategory = true
        localLabel.font = .govUK.largeTitleBold
        localLabel.numberOfLines = 0
        localLabel.textAlignment = .left
        localLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        localLabel.accessibilityTraits = .header
        localLabel.textColor = .govUK.text.header
        return localLabel
    }()
}
