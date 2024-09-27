import SwiftUI

struct GroupedList: View {
    var content: [GroupedListSection]
    var backgroundColor: UIColor?

    var body: some View {
        if content.count >= 1 {
            ZStack {
                Color(backgroundColor ?? .clear)
                VStack {
                    ForEach(content, id: \.heading) { section in
                        GroupedListSectionView(section: section)
                    }
                }
                .frame(idealWidth: UIScreen.main.bounds.width)
            }
        }
    }
}
