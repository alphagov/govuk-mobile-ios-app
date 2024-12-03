import SwiftUI

struct GroupedListSectionIconView: View {
    let heading: GroupedListHeader
    let rows: [GroupedListRow]
    let footer: String?
    private let cornerRadius: CGFloat = 10

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ZStack {
                Color(UIColor.govUK.fills.surfaceCard)
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(uiImage: heading.icon ?? UIImage())
                            .padding(.leading, 16)
                            .padding(.vertical, 16)
                        Text(heading.title)
                            .font(Font.govUK.title3.bold())
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .accessibilityAddTraits(.isHeader)
                            .padding(.leading, 8)
                    }
                    Divider()
                        .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
                    ForEach(
                        Array(zip(rows,
                                  rows.indices)),
                        id: \.0.id
                    ) { row, index in
                        if index > 0 {
                            Divider()
                                .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
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
                        Color(UIColor.govUK.strokes.listDivider),
                        lineWidth: SinglePixelLineHelper.pixelSize,
                        antialiased: true
                    )
            )

            if let footer = footer {
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
        let section = GroupedListSection_Previews.previewContent.last!
        GroupedListSectionIconView(
            heading: section.heading!,
            rows: section.rows,
            footer: section.footer
        )
    }
}
