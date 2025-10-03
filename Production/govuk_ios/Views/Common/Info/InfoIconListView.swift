import SwiftUI
import UIKit

struct InfoIconListView: View {
    let list: [InfoIconListItem]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(list.indices, id: \.self) { index in
                listItemView(list[index])
                    .padding(paddingEdges(for: index))
                if index < list.count - 1 {
                    Divider()
                        .overlay(Color(UIColor.govUK.strokes.chatOnboardingListDivider))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
            }
        }
        .background(Color(UIColor.govUK.fills.surfaceChatOnboardingListBackground))
        .cornerRadius(10)
    }

    private func listItemView(_ listItem: InfoIconListItem) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: listItem.iconName)
                .foregroundColor(Color(UIColor.govUK.text.trailingIcon))
                .accessibilityHidden(true)
            Text(listItem.text)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.body)
        }
        .padding(.horizontal, 16)
    }

    private func paddingEdges(for index: Int) -> EdgeInsets {
        let verticalPadding: CGFloat = 16
        var top: CGFloat = 0
        var bottom: CGFloat = 0

        if list.count == 1 {
            top = verticalPadding
            bottom = verticalPadding
        } else if index == 0 {
            top = verticalPadding
        } else if index == list.count - 1 {
            bottom = verticalPadding
        }

        return EdgeInsets(top: top, leading: 0, bottom: bottom, trailing: 0)
    }
}

struct InfoIconListItem {
    var text: String
    var iconName: String
}
