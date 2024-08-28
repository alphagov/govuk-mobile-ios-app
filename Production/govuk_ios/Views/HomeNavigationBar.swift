import Foundation
import UIKit

class HomeNavigationBar: UIView {
    let sittingHeight: CGFloat = 56
    let scrolledHeight: CGFloat = 50

    private lazy var heightConstraint = heightAnchor.constraint(
        equalToConstant: sittingHeight
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
        uiImageView.accessibilityHint = NSLocalizedString(
            "homeScreenLogoAccessibilityHint",
            comment: ""
        )
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
        backgroundColor = UIColor.govUK.fills.surfaceBackground
        addSubview(divider)
        addSubview(logoImageView)
    }

    private func configureConstraints() {
        let ratio = (logoImageView.image?.size.height ?? 1) /
                    (logoImageView.image?.size.width ?? 1)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(lessThanOrEqualToConstant: sittingHeight),
            heightAnchor.constraint(greaterThanOrEqualToConstant: scrolledHeight),
            heightConstraint,

            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leftAnchor.constraint(equalTo: leftAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            logoImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -12
            ),
            logoImageView.heightAnchor.constraint(
                equalTo: logoImageView.widthAnchor,
                multiplier: ratio
            )
        ])
    }

    func handleScroll(scrollView: UIScrollView) {
        guard scrollView.frame != .zero else { return }

        let adjustedScroll = (scrollView.verticalScroll / 7)
        var offset = sittingHeight - adjustedScroll

        if offset < scrolledHeight {
            offset = scrolledHeight
        } else if offset > sittingHeight {
            offset = sittingHeight
        }

        heightConstraint.constant = offset
        let diff = adjustedScroll / (sittingHeight - scrolledHeight)
        divider.alpha = diff
    }
}
