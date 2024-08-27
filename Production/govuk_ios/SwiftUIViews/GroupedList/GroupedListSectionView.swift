import SwiftUI

struct GroupedListSectionView: View {
    let section: GroupedListSection

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text(section.heading)
                .font(Font.govUK.title3Semibold)
            ForEach(section.rows, id: \.title) { row in
                GroupedListRowView(row: row)
            }
        }
        .padding()
    }
}

#Preview {
    GroupedListSectionView(section: GroupedListSection.previewContent.first!)
}
