import Foundation
import UIKit

class StickyFooterView: UIView {
    private lazy var stackView: UIStackView = {
        let localView = UIStackView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.axis = .vertical
        localView.distribution = .fillEqually
        localView.spacing = 4
        return localView
    }()

    private lazy var divider: UIView = {
        let localView = UIView()
        localView.backgroundColor = UIColor.govUK.strokes.listDivider
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    init() {
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        layoutMargins = .init(all: 16)
        addSubview(divider)
        addSubview(stackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(
                equalToConstant: 0.33
            ),
            divider.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            divider.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            divider.topAnchor.constraint(
                equalTo: topAnchor
            ),
            stackView.topAnchor.constraint(
                equalTo: divider.bottomAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            )
        ])
    }

    func addView(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        stackView.axis = traitCollection.verticalSizeClass == .compact ? .horizontal : .vertical
    }
}
