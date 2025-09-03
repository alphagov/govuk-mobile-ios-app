import Foundation
import SwiftUI

struct UserFeedbackWidgetView: View {
    let viewModel: UserFeedbackWidgetViewModel

    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.body)
                .font(.govUK.body)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .accessibilitySortPriority(100)
            Spacer()
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
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(UIColor.govUK.text.link))
            }
        )
        .accessibilityAddTraits(.isLink)
        .accessibilityHint(String.common.localized("openWebLinkHint"))
        .accessibilitySortPriority(50)
    }
}
