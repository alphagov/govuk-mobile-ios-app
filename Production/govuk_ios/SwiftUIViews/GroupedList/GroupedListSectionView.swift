import SwiftUI

struct GroupedListSectionView: View {
    let section: GroupedListSection

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text(section.heading)
                .font(Font.govUK.title3.bold())
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .padding(.horizontal, 16)
            ZStack {
                Color(UIColor.govUK.fills.surfaceCard)
                VStack {
                    ForEach(section.rows, id: \.title) { row in
                        GroupedListRowView(row: row)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(
                        Color(UIColor.govUK.strokes.listDivider),
                        lineWidth: 1.0,
                        antialiased: true
                    )
            )
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color(UIColor.govUK.Fills.surfaceBackground)
        GroupedListSectionView(section: GroupedListSection.previewContent.first!)
    }
}
