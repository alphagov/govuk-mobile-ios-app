import Foundation
import SwiftUI

struct GroupedListDetailRowView: View {
    var row: GroupedListDetailRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(row.destructive ?
                                         Color(UIColor.govUK.text.buttonDestructive) :
                                            Color(UIColor.govUK.text.primary))
                    Spacer()
                    Text(row.body)
                        .font(Font.govUK.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
                GroupedListRowDetailView(text: row.body)
            }
        }
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(row.accessibilityHint)
    }
}

