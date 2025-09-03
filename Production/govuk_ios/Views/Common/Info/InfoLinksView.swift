import SwiftUI
import GOVKit
import UIComponents

struct InfoLinksView: View {
    let linkList: [InfoLinkListItem]
    let openURLAction: (URL) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 22) {
            ForEach(linkList, id: \.text) { linkListItem in
                linkView(
                    text: linkListItem.text,
                    url: linkListItem.url
                )
            }
        }
        .padding(.top, 16)
    }

    private func linkView(text: String, url: URL) -> some View {
        Button(
            action: { openURLAction(url) },
            label: {
                Spacer()
                Text(text)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.center)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .fontWeight(.semibold)
            }
        )
    }
}

struct InfoLinkListItem {
    let text: String
    let url: URL
}
