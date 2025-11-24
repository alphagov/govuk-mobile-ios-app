import Foundation
import UIKit

public class GroupedListSectionHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.font = UIFont.govUK.title3Semibold
        localView.textColor = UIColor.govUK.text.primary
        localView.accessibilityTraits = .header
        return localView
    }()

    public var text: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(titleLabel)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8
            ),
            titleLabel.rightAnchor.constraint(
                equalTo: rightAnchor
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            ),
            titleLabel.leftAnchor.constraint(
                equalTo: leftAnchor,
            )
        ])
    }
}
