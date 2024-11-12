import UIKit
import Foundation
import UIComponents

class WidgetView: UIView {
    private(set) lazy var contentView = UIView()
    private let decorateView: Bool

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
            layer.borderColor = UIColor.govUK.strokes.listDivider.cgColor
        }
    }

    private func configureUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if decorateView {
            layer.borderWidth = 1
            layer.cornerRadius = 10
            layer.masksToBounds = true
            layoutMargins = .init(all: 16)
        }
        addSubview(contentView)
        updateBorderColor()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(
                equalTo: layoutMarginsGuide.topAnchor
            ),
            contentView.rightAnchor.constraint(
                equalTo: layoutMarginsGuide.rightAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: layoutMarginsGuide.bottomAnchor
            ),
            contentView.leftAnchor.constraint(
                equalTo: layoutMarginsGuide.leftAnchor
            )
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
