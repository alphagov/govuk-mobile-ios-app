import SwiftUI
import CoreData

struct RecentItemsView: View {
    let model: RecentItemsViewStructure
    init(model: RecentItemsViewStructure) {
        self.model = model
    }

    var body: some View {
        List {
            TodaysRecentlyVistiedItems(items: model.todaysItems)
            ItemsVisitedThisMonthView(items: model.thisMonthsItems)
            ItemsVisitedInRecentMonthsView(visitedItems: model.otherMonthItems,
                                           monthAndYears: model.listOfOtherItemDateStrings)
        }.listStyle(.insetGrouped)
    }
}
