import GDSCommon
import SwiftUI

protocol WrappableButton: UIButton {
    var icon: String? { get set }

    init(action: UIAction)
}

extension WrappableButton {
    var icon: String? { nil }
}

extension SecondaryButton: WrappableButton {}

struct ButtonWrapper<WrappedButton: WrappableButton>: UIViewRepresentable {
    private let action: UIAction

    let title: String
    let icon: String?

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

    func makeUIView(context: Context) -> WrappedButton {
        let button = WrappedButton(action: action)

        if let icon {
            button.icon = icon
        }

        button.setTitle(title, for: .normal)

        return button
    }

    func updateUIView(_ uiView: WrappedButton, context: Context) {
        // required for protocol conformance
    }

    func makeCoordinator() -> Self.Coordinator {
        // required for protocol conformance
    }
}
