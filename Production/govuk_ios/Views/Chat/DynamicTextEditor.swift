import SwiftUI

struct DynamicTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    var placeholderText: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.font = UIFont.govUK.body
        textView.backgroundColor = UIColor.govUK.fills.surfaceChatBlue
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = context.coordinator

        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont.govUK.body.withSize(17)
        placeholderLabel.textColor = UIColor.govUK.text.secondary

        textView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(
                equalTo: textView.leadingAnchor
            ),
            placeholderLabel.centerYAnchor.constraint(
                equalTo: textView.centerYAnchor
            )
        ])

        context.coordinator.placeholderLabel = placeholderLabel

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        DynamicTextEditor.recalculateHeight(view: uiView, result: $dynamicHeight)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $dynamicHeight)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var height: CGFloat
        weak var placeholderLabel: UILabel?

        init(text: Binding<String>, height: Binding<CGFloat>) {
            self._text = text
            self._height = height
        }

        func textViewDidChange(_ textView: UITextView) {
            $text.wrappedValue = textView.text
            DynamicTextEditor.recalculateHeight(view: textView, result: $height)
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            placeholderLabel?.isHidden = true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            placeholderLabel?.isHidden =
            textView.isFirstResponder || !textView.text.isEmpty
        }
    }

    static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(
            CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)
        )
        DispatchQueue.main.async {
            result.wrappedValue = newSize.height
        }
    }
}
