import Foundation
import SwiftUI

struct GroupedListDetailRowView: View {
    var row: DetailRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    GroupedListRowTitle(row.title)
                    Spacer()
                    Text(row.body)
                        .font(Font.govUK.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
            }
        }
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(row.accessibilityHint)
    }
}
