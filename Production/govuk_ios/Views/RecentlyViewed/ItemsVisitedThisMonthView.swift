import SwiftUI
import Foundation

struct ItemsVisitedThisMonthView: View {
    let items: [RecentItem]
    var body: some View {
        if items.count >= 1 {
            Section(header: Text("This Month")
                .font(.title3)
                .fontWeight(.semibold)
                .textCase(nil)
                .foregroundColor(Color(UIColor.govUK.text.primary))) {
                ForEach(items) {item in
                    RecentItemCell(model: item)
                }
            }
        }
    }
}
