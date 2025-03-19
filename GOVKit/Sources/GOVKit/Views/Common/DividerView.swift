import Foundation
import UIKit

public final class DividerView: UIView {
    public init() {
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
        heightAnchor.constraint(equalToConstant: SinglePixelLineHelper.pixelSize).isActive = true
    }
}
