import Foundation
import SwiftUI

struct UserFeedbackWidgetView: View {
    let viewModel: UserFeedbackWidgetViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(viewModel.body)
                .font(.govUK.body)
                .multilineTextAlignment(.center)
                .foregroundColor(
                    Color(UIColor.govUK.text.primary)
                )
                .accessibilitySortPriority(100)
            linkButton(title: viewModel.linkTitle)
        }
        .padding(.top)
        .padding(.bottom, 28)
    }

    @ViewBuilder
    private func linkButton(title: String) -> some View {
        Button(
            action: {
                self.viewModel.open()
            }, label: {
                Text(title)
                    .font(.govUK.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(
                        Color(uiColor: UIColor.govUK.text.buttonSecondary)
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 18)
            }
        )
        .accessibilityAddTraits(.isLink)
        .accessibilityHint(
            String.common.localized("openWebLinkHint")
        )
        .accessibilitySortPriority(50)
    }
}
