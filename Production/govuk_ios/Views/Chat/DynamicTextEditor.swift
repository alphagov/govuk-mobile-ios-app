import SwiftUI

struct DynamicTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var placeholderText: String?

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.govUK.fills.surfaceChatBlue
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = context.coordinator
        textView.font = .govUK.body

        let placeholderLabel = UILabel()
        placeholderLabel.adjustsFontForContentSizeCategory = true
        placeholderLabel.text = placeholderText
        placeholderLabel.font = .govUK.body
        placeholderLabel.textColor = UIColor.govUK.text.secondary
        placeholderLabel.tag = 100
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        textView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(
                equalTo: textView.leadingAnchor, constant: 5
            ),
            placeholderLabel.topAnchor.constraint(
                equalTo: textView.topAnchor, constant: 8
            ),
            placeholderLabel.bottomAnchor.constraint(
                equalTo: textView.bottomAnchor
            )
        ])

        let widthConstraint = placeholderLabel.widthAnchor.constraint(
            lessThanOrEqualToConstant: 300
        )
        widthConstraint.identifier = "widthConstraint"
        widthConstraint.isActive = true
        placeholderLabel.isHidden = !text.isEmpty
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification,
                                               object: nil,
                                               queue: .main) { _ in
            DynamicTextEditor.recalculateHeight(view: textView, result: self.$dynamicHeight)
        }

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if let placeholderLabel = uiView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !text.isEmpty
            if !placeholderLabel.isHidden {
                let widthConstraint =
                placeholderLabel.constraints.first { $0.identifier == "widthConstraint" }
                widthConstraint?.constant = uiView.frame.width
                DynamicTextEditor.recalculateHeight(view: placeholderLabel, result: $dynamicHeight)
            } else {
                DynamicTextEditor.recalculateHeight(view: uiView, result: $dynamicHeight)
            }
        } else {
            DynamicTextEditor.recalculateHeight(view: uiView, result: $dynamicHeight)
        }
    }

    func dismantleUIView(_ uiView: UITextView, coordinator: Coordinator) {
        NotificationCenter.default.removeObserver(
            uiView,
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: DynamicTextEditor

        init(_ parent: DynamicTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = !textView.text.isEmpty
            }
            DynamicTextEditor.recalculateHeight(view: textView, result: parent.$dynamicHeight)
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = true
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = !textView.text.isEmpty
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
