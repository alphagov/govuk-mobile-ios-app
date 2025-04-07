import Foundation
import SwiftUI

struct GroupedListToggleRowView: View {
    @StateObject var row: ToggleRow
    var body: some View {
        HStack {
            Spacer()
            Toggle(isOn: $row.isOn) {
                GroupedListRowTitleView(row.title)
                .padding(.horizontal, -8)
            }
            .toggleStyle(SwitchToggleStyle(tint: (Color(UIColor.govUK.fills.surfaceToggleSelected))))
        }
    }
}
