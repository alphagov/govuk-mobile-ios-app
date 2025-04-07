import Foundation
import SwiftUI

struct GroupedListLinkRowView: View {
    let row: LinkRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    GroupedListRowTitle(
                        row.title,
                        color: Color(UIColor.govUK.text.link)
                    )
                    .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                }
                .foregroundColor(Color(UIColor.govUK.text.link))

                GroupedListRowFooter(text: row.body)
            }
        }
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(row.isWebLink ? .isLink : .isButton)
        .accessibilityHint(row.isWebLink ? String.common.localized("openWebLinkHint") : "")
    }
}
