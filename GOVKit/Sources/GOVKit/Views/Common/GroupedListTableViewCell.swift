import Foundation
import UIKit

public class GroupedListTableViewCell: UITableViewCell {
    private lazy var horizontalStackView: UIStackView = {
        let localView = UIStackView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .horizontal
        localView.alignment = .firstBaseline
        localView.spacing = 10
        return localView
    }()

    private lazy var verticalStackView: UIStackView = {
        let localView = UIStackView()
        localView.axis = .vertical
        localView.spacing = 4
        return localView
    }()

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        localView.font = UIFont.govUK.body
        localView.textColor = UIColor.govUK.text.link
        return localView
    }()

    private lazy var bodyLabel: UILabel = {
        let localView = UILabel()
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        localView.font = UIFont.govUK.subheadline
        localView.textColor = UIColor.govUK.text.secondary
        return localView
    }()

    private lazy var iconImageView: UIImageView = {
        let localView = UIImageView()
        localView.image = UIImage(systemName: "arrow.up.right")
        localView.tintColor = UIColor.govUK.text.iconTertiary
        return localView
    }()

    private lazy var separatorView: DividerView = {
        let localView = DividerView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private let borderWidth: CGFloat = 0.5
    private var isTop = false
    private var isBottom = false

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        clipsToBounds = true

        backgroundColor = UIColor.govUK.fills.surfaceList
        contentView.backgroundColor = UIColor.govUK.fills.surfaceList
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(separatorView)

        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(iconImageView)

        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(bodyLabel)

        // Removes the grey background for cell selection
        selectedBackgroundView = UIView()
        multipleSelectionBackgroundView = UIView()

        // Tints the checkmark
        tintColor = UIColor.govUK.fills.surfaceToggleSelected

        accessibilityTraits.insert(.link)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16
            ),
            horizontalStackView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -16
            ),
            horizontalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16
            ),
            horizontalStackView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: 16
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: 22
            ),
            iconImageView.widthAnchor.constraint(
                equalToConstant: 17
            ),
            separatorView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -16
            ),
            separatorView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            separatorView.leftAnchor.constraint(
                equalTo: titleLabel.leftAnchor
            )
        ])
    }

    public func configure(
        title: String,
        description: String?,
        top: Bool,
        bottom: Bool,
        showIconImage: Bool = true
    ) {
        self.isTop = top
        self.isBottom = bottom
        titleLabel.text = title
        bodyLabel.text = description
        separatorView.isHidden = bottom
        iconImageView.isHidden = !showIconImage
        updateMask()
        accessibilityHint = String.common.localized("openWebLinkHint")
    }

    public override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            accessibilityHint = nil
            accessibilityTraits.remove(.link)
        } else {
            accessibilityHint = String.common.localized("openWebLinkHint")
            accessibilityTraits.insert(.link)
        }
        UIView.animate(
            withDuration: 0.32,
            animations: {
                self.iconImageView.alpha = editing ? 0 : 1
            }
        )
    }

    public override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)
        invalidateIntrinsicContentSize()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    private func updateMask() {
        layer.maskedCorners = maskedCorners()
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // This is overridden to prevent the checkmark flickering when scrolling
        super.setHighlighted(false, animated: false)
    }

    private var isOnlyCell: Bool {
        isTop && isBottom
    }

    private var isMiddleCell: Bool {
        !isTop && !isBottom
    }

    private func roundedCorners() -> UIRectCorner {
        var corners: UIRectCorner = []
        if isTop {
            corners.insert([.topLeft, .topRight])
        }
        if isBottom {
            corners.insert([.bottomLeft, .bottomRight])
        }
        return corners
    }

    private func maskedCorners() -> CACornerMask {
        var corners: CACornerMask = []
        if isTop {
            corners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if isBottom {
            corners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        return corners
    }
}
