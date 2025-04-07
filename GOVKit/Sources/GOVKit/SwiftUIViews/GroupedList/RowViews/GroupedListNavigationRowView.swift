import Foundation
import SwiftUI

struct GroupedListNavigationRowView: View {
    let row: NavigationRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    GroupedListRowTitleView(
                        row.title
                    )
                    .multilineTextAlignment(.leading)
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
