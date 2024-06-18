import GDSCommon
import SwiftUI

struct PrimaryButton: UIViewRepresentable {
    private let action: UIAction
    let title: String
    let icon: String?

    func makeUIView(context: Context) -> RoundedButton {
        let button = RoundedButton()

        if let icon {
            button.icon = icon
        }

        button.setTitle(title, for: .normal)
        button.addAction(action, for: .touchUpInside)

        return button
    }

    func updateUIView(_ uiView: RoundedButton, context: Context) { }

    func makeCoordinator() -> Self.Coordinator { }

    init(title: String,
         icon: String? = nil,
         action:
         @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = UIAction { _ in
            action()
        }
    }
}
