import Foundation
import SwiftUI

struct GroupedListInformationRowView: View {
    let row: InformationRow

    var body: some View {
        Button {
            row.action?()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    GroupedListRowTitleView(row.title)
                    Spacer()
                    Text(row.detail)
                        .foregroundColor(color)
                }.accessibilityElement(children: .combine)

                GroupedListRowBodyView(text: row.body)
            }
        }
        .disabled(row.action == nil)
    }

    private var color: Color {
        Color(
            row.action == nil
            ? UIColor.govUK.text.secondary
            : UIColor.govUK.text.link
        )
    }
}
