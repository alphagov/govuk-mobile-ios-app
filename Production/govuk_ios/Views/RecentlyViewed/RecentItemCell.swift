import SwiftUI
import UIComponents

struct RecentItemCell: View {
    let model: RecentItem
    var body: some View {
        VStack(alignment: .leading, content: {
            HStack(content: {
                Text(model.title)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                    .accessibilityLabel(Text(model.title))
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(UIColor.govUK.text.link))
            })
            VStack(alignment: .leading, content: {
                Text(model.formattedDate)
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                    .accessibilityHint("")
            })
        }).accessibility(addTraits: .isLink)
          .accessibilityHint("")
        .onTapGesture {
            if let url = URL(string: model.url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
