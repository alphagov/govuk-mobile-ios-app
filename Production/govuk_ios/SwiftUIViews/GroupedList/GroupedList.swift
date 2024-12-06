import SwiftUI

struct GroupedList: View {
    var content: [GroupedListSection]
    var backgroundColor: UIColor?

    var body: some View {
        if content.count >= 1 {
            ZStack {
                Color(backgroundColor ?? .clear)
                VStack {
                    ForEach(content, id: \.heading?.title) { section in
                        if section.heading?.icon != nil {
                            GroupedListSectionIconView(
                                section: section
                            )
                        } else {
                            GroupedListSectionView(
                                section: section
                            )
                        }
                    }
                }
                .frame(idealWidth: UIScreen.main.bounds.width)
            }
        }
    }
}
