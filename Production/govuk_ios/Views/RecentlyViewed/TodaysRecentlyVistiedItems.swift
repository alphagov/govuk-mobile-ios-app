import SwiftUI

struct TodaysRecentlyVistiedItems: View {
    let items: [ActivityItem]
    var body: some View {
        if items.count >= 1 {
            Section(header: Text(NSLocalizedString(
                "todayItemsSectionHeader",
                bundle: .main,
                comment: "")).font(.title3)
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
