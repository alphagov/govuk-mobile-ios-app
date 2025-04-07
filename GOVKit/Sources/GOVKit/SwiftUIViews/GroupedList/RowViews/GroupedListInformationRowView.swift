import Foundation
import SwiftUI

struct GroupedListInformationRowView: View {
    let row: InformationRow

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                GroupedListRowTitle(row.title)
                Spacer()
                Text(row.detail)
                    .foregroundColor(
                        Color(
                            UIColor.govUK.text.secondary
                        )
                    )
            }.accessibilityElement(children: .combine)

            GroupedListRowFooter(text: row.body)
        }
    }
}
