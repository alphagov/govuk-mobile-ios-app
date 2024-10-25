import Foundation
import UIKit

class GroupedListTableViewCell: UITableViewCell {
    private lazy var verticalStackView: UIStackView = {
        let localView = UIStackView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .vertical
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
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.image = UIImage(systemName: "arrow.up.right")
        localView.tintColor = UIColor.govUK.text.link
        return localView
    }()

    private lazy var borderLayer: CAShapeLayer = {
        let localLayer = CAShapeLayer()
        localLayer.lineWidth = borderWidth
        localLayer.strokeColor = UIColor.govUK.strokes.listDivider.cgColor
        localLayer.fillColor = UIColor.clear.cgColor
        return localLayer
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
        layer.addSublayer(borderLayer)
        layer.masksToBounds = true
        layer.cornerRadius = 10
        clipsToBounds = true

        contentView.addSubview(verticalStackView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(separatorView)

        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(bodyLabel)

        // Removes the grey background for cell selection
        selectedBackgroundView = UIView()
        multipleSelectionBackgroundView = UIView()

        // Tints the checkmark
        tintColor = UIColor.govUK.text.link

        accessibilityTraits.insert(.link)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 11
            ),
            verticalStackView.rightAnchor.constraint(
                equalTo: iconImageView.leftAnchor,
                constant: -10
            ),
            verticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -11
            ),
            verticalStackView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor,
                constant: 16
            ),
            iconImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 11
            ),
            iconImageView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor,
                constant: -16
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: 22
            ),
            iconImageView.widthAnchor.constraint(
                equalToConstant: 17
            ),

            separatorView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor
            ),
            separatorView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            separatorView.leftAnchor.constraint(
                equalTo: titleLabel.leftAnchor
            )
        ])
    }

    func configure(title: String,
                   description: String?,
                   top: Bool,
                   bottom: Bool) {
        self.isTop = top
        self.isBottom = bottom
        titleLabel.text = title
        bodyLabel.text = description
        separatorView.isHidden = bottom
        updateMask()
        accessibilityHint = String.common.localized("openWebLinkHint")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    private func updateMask() {
        layer.maskedCorners = maskedCorners()
        borderLayer.path = UIBezierPath(
            roundedRect: borderFrame(),
            byRoundingCorners: roundedCorners(),
            cornerRadii: CGSize(width: 10, height: 10)
        ).cgPath
    }

    private func borderFrame() -> CGRect {
        var newFrame = bounds
        newFrame.size.height -= borderWidth
        newFrame.size.width -= borderWidth

        let originDelta: CGFloat = borderWidth / 2
        newFrame.origin = .init(x: originDelta, y: originDelta)

        guard !isOnlyCell else { return newFrame }
        newFrame.size.height = bounds.height + borderWidth

        if isBottom {
            newFrame.origin.y = -borderWidth
        } else if isMiddleCell {
            newFrame.origin.y = -originDelta
        }
        return newFrame
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
