import Foundation
import UIKit

class HomeNavigationBar: UIView {
    lazy var divider: UIView = {
        let border = DividerView()
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()

    lazy var logoImageView: UIImageView = {
        let uiImageView = UIImageView(image: .homeLogo)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leftAnchor.constraint(equalTo: leftAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
