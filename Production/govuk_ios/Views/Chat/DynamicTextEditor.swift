import SwiftUI

struct DynamicTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = context.coordinator
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
        var text: Binding<String>
        var height: Binding<CGFloat>

        init(text: Binding<String>, height: Binding<CGFloat>) {
            self.text = text
            self.height = height
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
            DynamicTextEditor.recalculateHeight(view: textView, result: height)
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
