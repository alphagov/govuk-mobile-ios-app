import SwiftUI
import Foundation

struct ItemsVisitedThisMonthView: View {
    let items: [ActivityItem]
    var body: some View {
        if items.count >= 1 {
            Section(header: Text(NSLocalizedString(
                "thisMonthsItemsSectionHeader",
                bundle: .main,
                comment: ""))
                .font(.title3)
                .fontWeight(.semibold)
                .textCase(nil)
                .foregroundColor(Color(UIColor.govUK.text.primary))) {
                ForEach(items) { item in
                    RecentItemCell(model: item)
                }
            }
        }
    }
}
