import SwiftUI

struct AltGroupedListSectionView: View {
    let section: AltGroupedListSection
    private let cornerRadius: CGFloat = 10

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            section.heading
            ZStack {
                Color(UIColor.govUK.fills.surfaceCard)
                VStack(spacing: 0) {
                    ForEach(0..<section.rows.count, id: \.self) { index in
                        Divider()
                            .foregroundColor(Color(UIColor.govUK.strokes.listDivider))
                            .padding(.leading, 16)
                        section.rows[index]
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
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
}


