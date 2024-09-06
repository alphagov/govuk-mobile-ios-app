import SwiftUI

struct TodaysRecentlyVistiedItems: View {
    let items: [RecentItem]
    var body: some View {
        if items.count >= 1 {
            Section(header: Text("Today").font(.title3)
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
