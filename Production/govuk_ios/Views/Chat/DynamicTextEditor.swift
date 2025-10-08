import SwiftUI

struct DynamicTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    @Binding var placeholderText: String?

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.govUK.fills.surfaceChatAction
        textView.adjustsFontForContentSizeCategory = true
        textView.delegate = context.coordinator
        textView.accessibilityLabel = placeholderText
        textView.font = .govUK.body
        textView.textColor = UIColor.govUK.text.primary

        let placeholderLabel = UILabel()
        placeholderLabel.adjustsFontForContentSizeCategory = true
        placeholderLabel.text = placeholderText
        placeholderLabel.font = .govUK.body
        placeholderLabel.textColor = UIColor.govUK.text.chatTextArea
        placeholderLabel.tag = 100
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.isAccessibilityElement = false
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
            ),
            placeholderLabel.widthAnchor.constraint(
                lessThanOrEqualToConstant: textView.frame.width
            )
        ])

        placeholderLabel.isHidden = !text.isEmpty
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification,
                                               object: nil,
                                               queue: .main) { _ in
            DynamicTextEditor.recalculateHeight(view: textView, result: self.$dynamicHeight)
        }

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if placeholderText == nil {
            DynamicTextEditor.recalculateHeight(view: textView, result: $dynamicHeight)
            return
        }

        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            textView.text = nil
            placeholderLabel.isHidden = false
            placeholderLabel.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
            let view = placeholderLabel.numberOfLinesUsed > 1 ? placeholderLabel : textView
            DynamicTextEditor.recalculateHeight(view: view, result: $dynamicHeight)
        }
    }

    func dismantleUIView(_ textView: UITextView, coordinator: Coordinator) {
        NotificationCenter.default.removeObserver(
            textView,
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
            DispatchQueue.main.async {
                self.parent.text = textView.text
            }
            if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = !textView.text.isEmpty
                parent.placeholderText = textView.text.isEmpty ? parent.placeholderText : nil
            }
            DynamicTextEditor.recalculateHeight(view: textView, result: parent.$dynamicHeight)
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
        if let placeholderLabel = view.viewWithTag(100) as? UILabel {
            let multipleLinePlaceholder =
            !placeholderLabel.isHidden && placeholderLabel.numberOfLinesUsed > 1
            let newPlaceholderHeight = multipleLinePlaceholder ?
            newSize.height + 16 : newSize.height
            DispatchQueue.main.async {
                result.wrappedValue = newPlaceholderHeight
            }
            return
        }
        DispatchQueue.main.async {
            result.wrappedValue = newSize.height
        }
    }
}

extension UILabel {
    var numberOfLinesUsed: Int {
        guard let text = self.text, let font = self.font else { return 0 }

        let maxSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let rect = NSString(string: text).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        let lineHeight = font.lineHeight
        let lines = Int(floor((rect.height / lineHeight) + 0.2))
        return lines
    }
}
