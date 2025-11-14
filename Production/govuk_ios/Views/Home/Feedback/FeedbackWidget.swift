import SwiftUI

struct FeedbackWidget: View {
    let action: () -> Void
    var body: some View {
        VStack {
            Text(String.home.localized("feedbackWidgetTitle"))
                .font(Font.govUK.body)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .padding(.bottom, 10)
            Button(
                action: {
                    action()
                },
                label: {
                    Text(String.home.localized("feedbackButtonTitle"))
                        .font(Font.govUK.body)
                        .foregroundColor(
                            Color(uiColor: UIColor.govUK.text.buttonSecondary)
                        )
                }
            )
        }
        .padding(.top)
        .padding(.bottom, 40)
    }
}

#Preview {
    FeedbackWidget(action: {})
}
