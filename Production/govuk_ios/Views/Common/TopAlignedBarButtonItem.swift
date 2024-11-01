import UIKit

class TopAlignedBarButtonItem: UIBarButtonItem {
    let customButton: UIButton

    init(title: String,
         tint: UIColor,
         action: @escaping (UIAction) -> Void) {
        customButton = UIButton(
            type: .system,
            primaryAction: .init(title: title, handler: action)
        )
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.titleLabel?.font = UIFont.govUK.body
        customButton.tintColor = tint

        super.init()
        self.customView = createContainer()
        self.customView?.isUserInteractionEnabled = true
    }

    private func createContainer() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(customButton)
        NSLayoutConstraint.activate([
            customButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            customButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            containerView.widthAnchor.constraint(equalTo: customButton.widthAnchor)
        ])
        return containerView
    }

    override var isEnabled: Bool {
        get {
            customButton.isEnabled
        }
        set {
            customButton.isEnabled = newValue
        }
    }

    func updateConstraints() {
        guard let view = customView,
        let superview = view.superview else { return }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
