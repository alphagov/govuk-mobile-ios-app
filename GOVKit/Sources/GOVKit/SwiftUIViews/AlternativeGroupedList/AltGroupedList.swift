import SwiftUI

struct AltGroupedList: View {
    var content: [AltGroupedListSection]
    var backgroundColor: UIColor?

    public var body: some View {
        if content.count >= 1 {
            ZStack {
                Color(backgroundColor ?? .clear)
                VStack {
                    ForEach(content, id: \.footer) { section in
                        AltGroupedListSectionView(
                            section: section
                        )
                    }
                }
                .frame(idealWidth: UIScreen.main.bounds.width)
            }
        }
    }
}

