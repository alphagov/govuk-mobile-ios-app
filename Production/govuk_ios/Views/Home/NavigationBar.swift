import Foundation
import UIKit

class NavigationBar: UIView {
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
        addSubview(logoImageView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            logoImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            logoImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -12
            )
        ])
    }
}
