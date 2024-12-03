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
                                heading: section.heading!,
                                rows: section.rows,
                                footer: section.footer
                            )
                        } else {
                            GroupedListSectionView(
                                heading: section.heading,
                                rows: section.rows,
                                footer: section.footer
                            )
                        }
                    }
                }
                .frame(idealWidth: UIScreen.main.bounds.width)
            }
        }
    }
}
