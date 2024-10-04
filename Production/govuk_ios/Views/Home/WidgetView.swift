import UIKit
import Foundation
import UIComponents

class WidgetView: UIView {
    private lazy var contentView: UIView = UIView(frame: .zero)
    private let decorateView: Bool
    private lazy var padding: CGFloat = {
        decorateView ? 16 : 0
    }()

    init(decorateView: Bool = true) {
        self.decorateView = decorateView
        super.init(frame: .zero)
        self.backgroundColor = decorateView ?
            UIColor.govUK.fills.surfaceCard :
            UIColor.govUK.fills.surfaceBackground
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBorderColor() {
        if decorateView {
            layer.borderColor = UIColor.secondaryBorder.cgColor
        }
    }

    private func configureUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if decorateView {
            layer.borderWidth = 1
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }
        addSubview(contentView)
        updateBorderColor()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding)
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
