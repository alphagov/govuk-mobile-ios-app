import SwiftUI

public struct GroupedList: View {
    var content: [GroupedListSection]
    var backgroundColor: UIColor?

    public init(content: [GroupedListSection],
                backgroundColor: UIColor? = nil) {
        self.content = content
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        if content.count >= 1 {
            ZStack {
                Color(backgroundColor ?? .clear)
                VStack(spacing: 16) {
                    ForEach(content, id: \.rows.first?.id) { section in
                        GroupedListSectionView(
                            section: section,
                            style: section.heading?.icon != nil ? .icon : .titled
                        )
                    }
                }
                .frame(idealWidth: UIScreen.main.bounds.width)
            }
        }
    }
}
