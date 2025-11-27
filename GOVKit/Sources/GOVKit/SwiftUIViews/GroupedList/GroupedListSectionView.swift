import SwiftUI

enum GroupedListSectionStyle {
    case titled
    case icon
}

struct GroupedListSectionView: View {
    let section: GroupedListSection
    let style: GroupedListSectionStyle
    private let cornerRadius: CGFloat = 10

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            if style == .titled {
                titleView
            }
            ZStack {
                Color(UIColor.govUK.fills.surfaceList)
                VStack(spacing: 0) {
                    if style == .icon {
                        iconView
                    }
                    ForEach(
                        Array(zip(section.rows, section.rows.indices)),
                        id: \.0.id
                    ) { row, index in
                        if index > 0 {
                            Divider()
                                .overlay(Color(UIColor.govUK.strokes.listDivider))
                                .padding(.leading, row.imageName == nil ? 16 : 72)
                                .padding(.trailing, 16)
                        }
                        GroupedListRowView(row: row)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            if let footer = section.footer {
                Text(footer)
                    .font(Font.govUK.footnote)
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                    .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var titleView: some View {
        if let title = section.heading?.title {
            HStack {
                Text(title)
                    .font(Font.govUK.title3.bold())
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button(action: {
                    section.heading?.action?()
                }, label: {
                    Text(section.heading?.actionTitle ?? "")
                        .foregroundColor(
                            Color(UIColor.govUK.text.buttonSecondary)
                        )
                        .font(Font.govUK.subheadlineSemibold)
                })
                .opacity(section.heading?.actionTitle == nil ? 0.0 : 1.0)
                .accessibilityLabel(section.heading?.accessibilityActionTitle ?? "")
            }
            .padding(.bottom, 8)
        } else {
            EmptyView()
        }
    }


    @ViewBuilder
    private var iconView: some View {
        HStack {
            Text(section.heading?.title ?? "")
                .font(Font.govUK.title3.bold())
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .accessibilityAddTraits(.isHeader)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.vertical, 8)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Image(uiImage: section.heading?.icon ?? UIImage())
                .renderingMode(.template)
                .foregroundStyle(Color(UIColor.govUK.text.trailingIcon))
                .padding(.trailing, 16)
                .padding(.vertical, 8)
                .accessibilityHidden(true)
        }
        .background(Color(UIColor.govUK.fills.surfaceListHeading))
        Divider()
            .overlay(Color(UIColor.govUK.strokes.listDivider))
    }
}

#Preview {
    ZStack {
        Color(UIColor.govUK.Fills.surfaceBackground)
        VStack {
            let titledSection = GroupedListSection_Previews.previewContent.first!
            GroupedListSectionView(
                section: titledSection,
                style: .titled
            )
            let iconSection = GroupedListSection_Previews.previewContent.last!
            GroupedListSectionView(
                section: iconSection,
                style: .icon
            )
        }
    }
}
