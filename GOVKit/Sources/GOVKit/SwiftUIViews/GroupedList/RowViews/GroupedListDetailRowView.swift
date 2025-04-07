import Foundation
import SwiftUI

struct GroupedListDetailRowView: View {
    let row: DetailRow

    var body: some View {
        if row.action == nil {
            stack
        } else {
            Button {
                row.action?()
            } label: {
                stack
            }
            .accessibilityHint(row.accessibilityHint ?? "")
        }
    }

    private var stack: some View {
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

    private var color: Color {
        Color(
            row.action == nil
            ? UIColor.govUK.text.secondary
            : UIColor.govUK.text.link
        )
    }
}
