import UIKit
import Foundation
import UIComponents

protocol WidgetInterface {
    var viewModel: HomeWidgetViewModel { get }
}

class WidgetView: UIView {
    private lazy var stackView: UIStackView = {
        let localView = (widget as? UIStackView)!
        localView.axis = .vertical
        localView.alignment = .center
        localView.spacing = 8
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private let widget: WidgetInterface

    init(widget: WidgetInterface) {
        self.widget = widget
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
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(stackView)
        updateBorderColor()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: widget.viewModel.widgetHeight),
            stackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorderColor()
    }
}
