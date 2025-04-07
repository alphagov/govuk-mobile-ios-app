import SwiftUI

struct GroupedListRowView: View {
    let row: any GroupedListRow

    var body: some View {
        Group {
            switch row {
            case let row as NavigationRow:
                GroupedListNavigationRowView(row: row)
            case let row as LinkRow:
                GroupedListLinkRowView(row: row)
            case let row as InformationRow:
                GroupedListInformationRowView(row: row)
            case let row as ToggleRow:
                GroupedListToggleRowView(row: row)
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
