import Foundation
import SwiftUI

struct GroupedListRowTitle: View {
    let title: String
    let color: Color

    init(_ title: String,
         color: Color = Color(UIColor.govUK.text.primary)) {
        self.title = title
        self.color = color
    }

    var body: some View {
        Text(title)
            .multilineTextAlignment(.leading)
            .foregroundColor(color)
    }
}
