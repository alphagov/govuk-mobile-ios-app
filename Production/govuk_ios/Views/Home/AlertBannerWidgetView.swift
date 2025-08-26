import Foundation
import SwiftUI

struct AlertBannerWidgetViewModel {
    let id: String
    let body: String
    let linkUrl: URL?
    let linkTitle: String?
    let dismiss: () -> Void

    init(alert: AlertBanner,
         dismiss: @escaping () -> Void) {
        self.id = alert.id
        self.body = alert.body
        self.linkUrl = alert.link?.url
        self.linkTitle = alert.link?.title
        self.dismiss = dismiss
    }

    func open() {
        guard let localUrl = linkUrl
        else { return }
        UIApplication.shared.open(
            localUrl,
            options: [:],
            completionHandler: nil
        )
    }
}

struct AlertBannerWidgetView: View {
    let viewModel: AlertBannerWidgetViewModel
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(viewModel.body)
                    .font(.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Spacer()
                Image(systemName: "x.circle")
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
