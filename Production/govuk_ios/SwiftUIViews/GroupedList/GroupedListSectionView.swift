import SwiftUI

struct GroupedListSectionView: View {
    let section: GroupedListSection
    private let cornerRadius: CGFloat = 10

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text(section.heading)
                .font(Font.govUK.title3.bold())
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .padding(.horizontal, 16)
            ZStack {
                Color(UIColor.govUK.fills.surfaceCard)
                VStack(spacing: 0) {
                    ForEach(
                        Array(zip(section.rows,
                                  section.rows.indices)),
                        id: \.0.title
                    ) { row, index in
                        GroupedListRowView(row: row)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        if index < section.rows.count - 1 {
                            Divider()
                                .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
                                .padding(.leading, 16)
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        Color(UIColor.govUK.strokes.listDivider),
                        lineWidth: SinglePixelLineHelper.pixelSize,
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
