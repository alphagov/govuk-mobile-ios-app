import SwiftUI

struct GroupedListRowView: View {
    let row: any GroupedListRow

    var body: some View {
        Group {
            switch row {
            case let row as GroupedListNavigationRow:
                GroupedListNavigationRowView(row: row)
            case let row as GroupedListLinkRow:
                GroupedListLinkRowView(row: row)
            case let row as GroupedListInformationRow:
                GroupedListInformationRowView(row: row)
            case let row as GroupedListToggleRow:
                GroupedListToggleRowView(row: row)
            case let row as GroupedListDetailRow:
                GroupedListDetailRowView(row: row)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    VStack {
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[0])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[1])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[2])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[3])
    }
}
