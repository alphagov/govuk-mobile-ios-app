import Foundation
import SwiftUI

struct GroupedListInformationRowView: View {
    let row: GroupedListInformationRow

    var body: some View {
        HStack {
            if let imageName = row.imageName {
                Image(imageName)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                    Spacer()
                    Text(row.detail)
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.secondary
                            )
                        )
                }
                GroupedListRowDetailView(text: row.body)
            }

        }.accessibilityElement(children: .combine)
    }
}
