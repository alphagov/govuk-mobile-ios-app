import SwiftUI

struct GroupedListSectionView: View {
    let section: GroupedListSection
    private let cornerRadius: CGFloat = 10

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            if let title = section.heading?.title {
                Text(title)
                    .font(Font.govUK.title3.bold())
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .padding(.horizontal, 16)
                    .accessibilityAddTraits(.isHeader)
            }
            ZStack {
                Color(UIColor.govUK.fills.surfaceList)
                VStack(spacing: 0) {
                    ForEach(
                        Array(zip(section.rows, section.rows.indices)),
                        id: \.0.id
                    ) { row, index in
                        if index > 0 {
                            Divider()
                                .overlay(Color(UIColor.govUK.strokes.listDivider))
                                .padding(.leading, 16)
                        }
                        GroupedListRowView(row: row)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        Color((UIColor.govUK.strokes.listDivider)),
                        lineWidth: SinglePixelLineHelper.pixelSize,
                        antialiased: true
                    )
            )

            if let footer = section.footer {
                Text(footer)
                    .font(Font.govUK.footnote)
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                    .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    ZStack {
        Color(UIColor.govUK.Fills.surfaceBackground)
        let section = GroupedListSection_Previews.previewContent.first!
        GroupedListSectionView(
            section: section
        )
    }
}
