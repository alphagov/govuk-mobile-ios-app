import Foundation
import UIKit

class DividerView: UIView {
    init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = UIColor.govUK.strokes.listDivider
    }

    private func configureConstraints() {
        heightAnchor.constraint(equalToConstant: 0.33).isActive = true
    }
}
