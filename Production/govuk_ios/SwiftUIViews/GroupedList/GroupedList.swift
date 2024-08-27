import SwiftUI

struct GroupedList: View {
    var content: [GroupedListSection] = GroupedListSection.previewContent

    var body: some View {
        ForEach(content, id: \.heading) { section in
            GroupedListSectionView(section: section)
        }
    }
}

#Preview {
    GroupedList()
}
