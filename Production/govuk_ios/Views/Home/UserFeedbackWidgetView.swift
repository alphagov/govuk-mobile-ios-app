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
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .accessibilitySortPriority(100)
            linkButton(title: viewModel.linkTitle)
        }
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
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .frame(width: 343)
                    .padding(.vertical, 16)
            }
        )
        .accessibilityAddTraits(.isLink)
        .accessibilityHint(String.common.localized("openWebLinkHint"))
        .accessibilitySortPriority(50)
    }
}
