import SwiftUI

struct HeaderViewComponent: View {
    let model: HeaderViewModel
    var body: some View {
        HStack {
            Text(model.title)
                .font(Font.govUK.title3Semibold)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .accessibilityAddTraits(.isHeader)
            Spacer()
            if let button = model.secondaryButton {
                Button {
                    button.action()
                } label: {
                    Text(button.title)
                        .foregroundColor(Color(UIColor.govUK.text.buttonSecondary))
                        .font(Font.govUK.subheadlineSemibold)
                }
                .accessibilityLabel(
                    button.accessibilityLabel ?? ""
                )
            }
        }
    }
}

struct HeaderViewModel {
    let title: String
    let secondaryButton: SecondaryButton?

    init(title: String,
         secondaryButton: SecondaryButton? = nil) {
        self.title = title
        self.secondaryButton = secondaryButton
    }

    struct SecondaryButton {
        let title: String
        let accessibilityLabel: String?
        let action: () -> Void?

        init(title: String,
             accessibilityLabel: String? = nil,
             action: @escaping () -> Void) {
            self.title = title
            self.accessibilityLabel = accessibilityLabel
            self.action = action
        }
    }
}
