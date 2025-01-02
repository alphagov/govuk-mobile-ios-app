import UIKit
import UIComponents

public final class TopAlignedBarButtonItem: UIBarButtonItem {
    public let actionButton: UIButton

    public init(title: String,
         tint: UIColor,
         action: @escaping (UIAction) -> Void) {
        actionButton = UIButton(
            type: .system,
            primaryAction: .init(title: title, handler: action)
        )
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.titleLabel?.font = UIFont.govUK.body
        actionButton.tintColor = tint

        super.init()
        self.customView = createCustomView()
        self.customView?.isUserInteractionEnabled = true
    }

    private func createCustomView() -> UIView {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: localView.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: localView.topAnchor, constant: 5),
            localView.widthAnchor.constraint(equalTo: actionButton.widthAnchor)
        ])
        return localView
    }

    public override var isEnabled: Bool {
        get {
            actionButton.isEnabled
        }
        set {
            actionButton.isEnabled = newValue
        }
    }

    public func updateLayout() {
        guard let view = customView,
        let superview = view.superview else { return }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        // Bar button items don't automatically respond to dynamic type changes,
        // so need to set the font again to reflect updates
        actionButton.titleLabel?.font = .govUK.body
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
