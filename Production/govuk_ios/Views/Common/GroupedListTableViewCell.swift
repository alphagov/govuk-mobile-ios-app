import Foundation
import UIKit

class GroupedListTableViewCell: UITableViewCell {
    private lazy var stackView: UIStackView = {
        let localView = UIStackView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .vertical
        return localView
    }()

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
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
        localLayer.lineWidth = 0.5
        localLayer.strokeColor = UIColor.govUK.strokes.listDivider.cgColor
        localLayer.fillColor = UIColor.clear.cgColor
        return localLayer
    }()

    private lazy var separatorView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        localView.backgroundColor = UIColor.govUK.strokes.listDivider
        return localView
    }()

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

        contentView.addSubview(stackView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(separatorView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 11
            ),
            stackView.rightAnchor.constraint(
                equalTo: iconImageView.leftAnchor,
                constant: -10
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -11
            ),
            stackView.leftAnchor.constraint(
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
                equalTo: contentView.leftAnchor,
                constant: 16
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    private func updateMask() {
        var corners: UIRectCorner = isTop ? [.topLeft, .topRight] : []
        var mainCorners: CACornerMask = []
        if isTop {
            mainCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if isBottom {
            corners =  [corners, .bottomLeft, .bottomRight]
            mainCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        layer.maskedCorners = mainCorners
        var newFrame = bounds
        newFrame.size.height += 4
        let widthDelta: CGFloat = 1
        newFrame.size.width -= widthDelta
        if isTop {
            newFrame.origin = .init(x: widthDelta / 2, y: 0.5)
        } else if isBottom {
            newFrame.origin = .init(x: widthDelta / 2, y: -4.5)
        } else {
            newFrame.origin = .init(x: widthDelta / 2, y: -2)
        }

        let path = UIBezierPath(
            roundedRect: newFrame,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 10, height: 10)
        )
        borderLayer.path = path.cgPath
    }
}
