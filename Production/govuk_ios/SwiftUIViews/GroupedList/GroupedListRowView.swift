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
    }
}

struct InformationRowView: View {
    let row: InformationRow

    var body: some View {
        HStack {
            Text(row.title)
            Spacer()
            Text(row.detail)
                .foregroundColor(
                    Color(
                        UIColor.govUK.text.trailingIcon
                    )
                )
        }
    }
}

struct LinkRowView: View {
    let row: LinkRow

    var body: some View {
        Button {
            row.action()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(row.title)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                }
                .foregroundColor(Color(UIColor.govUK.text.link))

                RowDetail(text: row.body)
            }
        }
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
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.primary
                            )
                        )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.trailingIcon
                            )
                        )
                        .font(Font.govUK.bodySemibold)
                }
            }
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
