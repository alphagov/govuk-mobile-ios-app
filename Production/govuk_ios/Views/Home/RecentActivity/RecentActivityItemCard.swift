import Foundation
import SwiftUI

struct RecentActivityItemCard: View {
    let model: RecentActivityHomepageCell
    let postitionInList: Int
    let isLastItemInList: Bool
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(model.title)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                        .multilineTextAlignment(.leading)
                    Text(model.lastVisitedString)
                        .font(Font.govUK.subheadline)
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                        .multilineTextAlignment(.leading)
                }.padding(.bottom, isLastItemInList ? 12: 0)
                Spacer()
            }.padding(.vertical, 8)
            if !isLastItemInList {
                Divider().overlay(Color.cyan)
            }
        }.background(Color(uiColor: UIColor.govUK.fills.surfaceList))
    }
}
