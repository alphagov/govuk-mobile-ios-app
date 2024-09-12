import SwiftUI

struct ItemsVisitedInRecentMonthsView: View {
    let visitedItems: [ActivityItem]
    let monthAndYears: [String]
    var body: some View {
        ForEach(monthAndYears, id: \.self) { date in
            Section(header: Text(date)
                .font(.title3)
                .fontWeight(.semibold)
                .textCase(nil)
                .foregroundColor(Color(UIColor.govUK.text.primary))) {
                    ForEach(visitedItems.filter({ DateHelper.getMonthAndYear(
                        date: $0.date) == date
                    }), id: \.self) { item in
                        RecentItemCell(model: item)
                    }
                }
        }
    }
}
