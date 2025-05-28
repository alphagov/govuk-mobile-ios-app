import Foundation
import SwiftUI

struct GroupedListRowDetailView: View {
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
