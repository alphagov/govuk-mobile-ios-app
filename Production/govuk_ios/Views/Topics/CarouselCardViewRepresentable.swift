import UIKit
import SwiftUI

struct CarouselCardViewRepresentable: UIViewRepresentable {
    let card: CarouselCard

    func makeUIView(context: Context) -> CarouselCardView {
        CarouselCardView(card: card)
    }

    func updateUIView(_ uiView: CarouselCardView, context: Context) { }
}

class CarouselCardView: UIControl {
    private let card: CarouselCard
    private let label = UILabel()
    private let bottomBorderShadow = UIView()
    private var heightConstraint: NSLayoutConstraint?

    init(card: CarouselCard) {
        self.card = card
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateHeight(_ height: CGFloat) {
        heightConstraint?.constant = height
        setNeedsLayout()
    }

    private func configureUI() {
        backgroundColor = .blue
        layer.cornerRadius = 10

        label.text = card.title
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = .govUK.bodySemibold
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        bottomBorderShadow.backgroundColor = .black
        bottomBorderShadow.layer.cornerRadius = 10
        bottomBorderShadow.layer.maskedCorners = [
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
        bottomBorderShadow.translatesAutoresizingMaskIntoConstraints = false

        addSubview(bottomBorderShadow)
        addSubview(label)
    }

    private func configureConstraints() {
        heightConstraint = heightAnchor.constraint(
            greaterThanOrEqualToConstant: 150
        )

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 150),
            heightConstraint!,

            bottomBorderShadow.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorderShadow.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorderShadow.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorderShadow.heightAnchor.constraint(equalToConstant: 3),

            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = label.sizeThatFits(
            CGSize(width: 118, height: CGFloat.greatestFiniteMagnitude)
        )
        return CGSize(width: 150, height: max(150, labelSize.height + 32))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory !=
            previousTraitCollection?.preferredContentSizeCategory {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
}
