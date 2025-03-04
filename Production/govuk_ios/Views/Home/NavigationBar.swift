import Foundation
import UIKit

class NavigationBar: UIView {
    let navBarHeight: CGFloat = 56

    private lazy var heightConstraint = heightAnchor.constraint(
        equalToConstant: navBarHeight
    )

    private lazy var logoBottomAnchor = logoImageView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -12
    )

    lazy var divider: UIView = {
        let border = DividerView()
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()

    lazy var logoImageView: UIImageView = {
        let uiImageView = UIImageView(image: .homeLogo)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.isAccessibilityElement = true
        uiImageView.accessibilityLabel = String.home.localized("logoAccessibilityTitle")
        uiImageView.accessibilityTraits = .header
        return uiImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.fills.surfaceHomeHeaderBackground
        addSubview(divider)
        addSubview(logoImageView)
    }

    private func configureConstraints() {
        let ratio = (logoImageView.image?.size.height ?? 1) /
                    (logoImageView.image?.size.width ?? 1)

        NSLayoutConstraint.activate([
            heightConstraint,

            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leftAnchor.constraint(equalTo: leftAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            logoBottomAnchor,
            logoImageView.heightAnchor.constraint(
                equalTo: logoImageView.widthAnchor,
                multiplier: ratio
            )
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.verticalSizeClass == .compact {
            logoImageView.isHidden = true
            heightConstraint.constant = 0
            NSLayoutConstraint.deactivate([logoBottomAnchor])
        } else {
            logoImageView.isHidden = false
            heightConstraint.constant = navBarHeight
            NSLayoutConstraint.activate([logoBottomAnchor])
        }
    }
}
