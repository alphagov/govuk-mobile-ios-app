import UIKit
import Foundation
import UIComponents

class WidgetView: UIView {
    private lazy var contentView: UIView = UIView(frame: .zero)

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.govUK.fills.surfaceCard
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBorderColor() {
        layer.borderColor = UIColor.secondaryBorder.cgColor
    }

    private func configureUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(contentView)
        updateBorderColor()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorderColor()
    }

    func addContent(_ content: UIView) {
        content.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(content)
        NSLayoutConstraint.activate(
            [
                content.topAnchor.constraint(equalTo: contentView.topAnchor),
                content.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                content.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            ]
        )
    }
}
