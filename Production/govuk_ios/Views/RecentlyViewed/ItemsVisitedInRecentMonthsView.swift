import SwiftUI

struct ItemsVisitedInRecentMonthsView: View {
    let visitedItems: [[RecentItem]]
    var body: some View {
        ForEach(visitedItems, id: \.self) { listOfRecentlyVisitedItems in
            Section(header: Text(DateHelper.getMonthAndYear(
                date: DateHelper.convertDateStringToDate(
                    dateString: listOfRecentlyVisitedItems[0].date)))
                .font(.title3)
                .fontWeight(.semibold)
                .textCase(nil)
                .foregroundColor(Color(UIColor.govUK.text.primary))) {
                    ForEach(listOfRecentlyVisitedItems, id: \.self) { item in
                        RecentItemCell(model: item)
                    }
                }
        }
    }
}
