import UIKit
import Foundation
import UIComponents

class WidgetView: UIView {
    private(set) lazy var contentView = UIView()
    private let decorateView: Bool
    private let cardBackgroundColor: UIColor
    private let borderColor: CGColor
    private lazy var padding: CGFloat = {
        decorateView ? 16 : 0
    }()

    init(decorateView: Bool = true,
         useContentAccessibilityInfo: Bool = false,
         backgroundColor: UIColor = UIColor.govUK.fills.surfaceCardBlue,
         borderColor: CGColor = UIColor.govUK.strokes.cardBlue.cgColor) {
        self.decorateView = decorateView
        self.cardBackgroundColor = backgroundColor
        self.borderColor = borderColor
        super.init(frame: .zero)
        self.backgroundColor = decorateView ?
        backgroundColor :
        UIColor.govUK.fills.surfaceBackground
        self.isAccessibilityElement = useContentAccessibilityInfo
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBorderColor() {
        if decorateView {
            layer.borderColor = borderColor
        }
    }

    private func configureUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        if decorateView {
            layer.borderWidth = 0.5
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }
        layoutMargins = .init(all: padding)
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
        configureAccessibility(for: content)
    }

    private func configureAccessibility(for content: UIView) {
        guard self.isAccessibilityElement else {
            return
        }
        accessibilityLabel = content.accessibilityLabel
        accessibilityHint = content.accessibilityHint
        accessibilityTraits = content.accessibilityTraits
    }
}
