import Foundation
import SwiftUI

struct RecentActivityItemCard: View {
    let model: RecentActivityHomepageCell
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
                }
                Spacer()
            }
            .padding(8)
            if !isLastItemInList {
                Divider()
                    .overlay(Color(UIColor.govUK.strokes.listDivider))
            }
        }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceList))
    }
}
