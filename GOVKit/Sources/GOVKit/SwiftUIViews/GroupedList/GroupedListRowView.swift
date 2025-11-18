import SwiftUI

struct GroupedListRowView: View {
    let row: any GroupedListRow

    var body: some View {
        Group {
            switch row {
            case let row as NavigationRow:
                NavigationRowView(row: row)
            case let row as LinkRow:
                LinkRowView(row: row)
            case let row as InformationRow:
                InformationRowView(row: row)
            case let row as ToggleRow:
                ToggleRowView(row: row)
            case let row as DetailRow:
                DetailRowView(row: row)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    VStack {
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[0])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[1])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[2])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[3])
        GroupedListRowView(row: GroupedListSection_Previews.previewContent.first!.rows[4])
    }
}

struct InformationRowView: View {
    let row: InformationRow

    var body: some View {
        HStack {
            if let imageName = row.imageName {
                Image(imageName)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                    Spacer()
                    Text(row.detail)
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.secondary
                            )
                        )
                }
                RowDetail(text: row.body)
            }

        }.accessibilityElement(children: .combine)
    }
}

struct LinkRowView: View {
    let row: LinkRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    if let imageName = row.imageName {
                        Image(imageName)
                    }
                    Text(row.title)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .opacity(row.showLinkImage ? 1 : 0)
                        .foregroundColor(Color(UIColor.govUK.text.iconTertiary))
                }
                RowDetail(text: row.body)
            }
        }
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(row.isWebLink ? .isLink : .isButton)
        .accessibilityHint(row.isWebLink ? String.common.localized("openWebLinkHint") : "")
    }
}

struct DetailRowView: View {
    var row: DetailRow
    
    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(row.destructive ?
                                         Color(UIColor.govUK.text.buttonDestructive) :
                                            Color(UIColor.govUK.text.primary))
                    Spacer()
                    Text(row.body)
                    .font(Font.govUK.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(UIColor.govUK.text.link))
                }
                RowDetail(text: row.body)
            }
        }
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(row.accessibilityHint)
    }
}

struct NavigationRowView: View {
    let row: NavigationRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.primary
                            )
                        )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.iconTertiary
                            )
                        )
                        .font(Font.govUK.bodySemibold)
                }
            }
        }
    }
}

struct ToggleRowView: View {
    @StateObject var row: ToggleRow
    var body: some View {
        HStack {
            Spacer()
            Toggle(isOn: $row.isOn) {
                Text(row.title)
                    .foregroundColor(
                        Color(
                            UIColor.govUK.text.primary
                        )
                    )
                    .padding(.horizontal, -8)
            }
            .toggleStyle(SwitchToggleStyle(tint: (Color(UIColor.govUK.fills.surfaceToggleSelected))))
        }
    }
}

struct RowDetail: View {
    let text: String?

    var body: some View {
        Group {
            if let text {
                Text(text)
                    .font(Font.govUK.subheadline)
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                    .multilineTextAlignment(.leading)
            } else {
                EmptyView()
            }
        }
    }
}
