import SwiftUI

struct DynamicTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var placeholderText: String?

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.font = UIFont.govUK.body
        textView.backgroundColor = UIColor.govUK.fills.surfaceChatBlue
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = context.coordinator
        textView.text = placeholderText
        textView.textColor = UIColor.govUK.text.secondary
        textView.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 4, right: 0)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if placeholderText != nil {
            uiView.text = placeholderText
            uiView.textColor = UIColor.govUK.text.secondary
        } else {
            uiView.text = text
            uiView.textColor = UIColor.govUK.text.primary
        }
        DynamicTextEditor.recalculateHeight(view: uiView, result: $dynamicHeight)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $dynamicHeight, placeholderText: $placeholderText)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var height: CGFloat
        @Binding var placeholderText: String?

        init(text: Binding<String>, height: Binding<CGFloat>, placeholderText: Binding<String?>) {
            self._text = text
            self._height = height
            self._placeholderText = placeholderText
        }

        func textViewDidChange(_ textView: UITextView) {
            $text.wrappedValue = textView.text
            DynamicTextEditor.recalculateHeight(view: textView, result: $height)
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            placeholderText = nil
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholderText
                textView.textColor = UIColor.govUK.text.secondary
            } else {
                textView.textColor = UIColor.govUK.text.primary
            }
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
