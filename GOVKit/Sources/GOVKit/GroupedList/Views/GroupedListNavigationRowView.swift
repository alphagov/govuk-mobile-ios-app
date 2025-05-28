import Foundation
import SwiftUI

struct GroupedListNavigationRowView: View {
    let row: GroupedListNavigationRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.primary
                            )
                        )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.trailingIcon
                            )
                        )
                        .font(Font.govUK.bodySemibold)
                }
            }
        }
    }
}

