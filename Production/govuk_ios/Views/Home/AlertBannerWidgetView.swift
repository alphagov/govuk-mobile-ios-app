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
                Spacer()
                Image(systemName: "xmark")
                    .onTapGesture {
                        viewModel.dismiss()
                    }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(viewModel.body)
            .accessibilityAddTraits(.isLink)
            .accessibilityHint(String.common.localized("openWebLinkHint"))
            .padding(.bottom, 4)
            if let titlelinkTitle = viewModel.linkTitle,
               !titlelinkTitle.isEmpty {
                HStack {
                    Text(titlelinkTitle)
                        .font(.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
        .background(Color(UIColor.govUK.fills.surfaceCardBlue))
        .onTapGesture {
            self.viewModel.open()
        }
    }
}
