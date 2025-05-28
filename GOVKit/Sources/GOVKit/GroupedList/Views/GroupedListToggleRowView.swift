import Foundation
import SwiftUI

struct GroupedListToggleRowView: View {
    @StateObject var row: GroupedListToggleRow
    var body: some View {
        HStack {
            Spacer()
            Toggle(isOn: $row.isOn) {
                Text(row.title)
                    .foregroundColor(
                        Color(
                            UIColor.govUK.text.primary
                        )
                    )
                    .padding(.horizontal, -8)
            }
            .toggleStyle(SwitchToggleStyle(tint: (Color(UIColor.govUK.fills.surfaceToggleSelected))))
        }
    }
}

