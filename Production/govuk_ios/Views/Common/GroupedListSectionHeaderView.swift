import Foundation
import UIKit

class GroupedListSectionHeaderView: UIView {
    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.font = UIFont.govUK.title3Semibold
        localView.textColor = UIColor.govUK.text.primary
        return localView
    }()

    var text: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
//        accessibilityTraits = .header
        addSubview(titleLabel)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor
            ),
            titleLabel.rightAnchor.constraint(
                equalTo: rightAnchor
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
            titleLabel.leftAnchor.constraint(
                equalTo: leftAnchor,
                constant: 16
            )
        ])
    }
}
