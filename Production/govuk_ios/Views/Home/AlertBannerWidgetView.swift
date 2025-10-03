import Foundation
import SwiftUI

struct AlertBannerWidgetView: View {
    let viewModel: AlertBannerWidgetViewModel

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(viewModel.body)
                    .font(.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .accessibilitySortPriority(100)
                Spacer()
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .accessibilityLabel(
                    String.home.localized("dismissAlertBannerAccessibilityLabel")
                )
                .foregroundColor(Color(UIColor.govUK.text.secondary))
                .accessibilitySortPriority(0)
            }
            Divider()
                .overlay(Color(UIColor.govUK.strokes.cardBlue))
                .padding(.vertical, 6)
            if let titlelinkTitle = viewModel.linkTitle,
               !titlelinkTitle.isEmpty {
                HStack {
                    linkButton(title: titlelinkTitle)
                    Spacer()
                }
            }
        }
        .background(Color(UIColor.govUK.fills.surfaceCardBlue))
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
