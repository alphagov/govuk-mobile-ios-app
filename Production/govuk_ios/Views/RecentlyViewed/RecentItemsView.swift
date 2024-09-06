import SwiftUI
import CoreData

struct RecentItemsView: View {
    let model: RecentItemsViewStructure
    @ObservedObject var viewModel: RecentItemsViewModel
    @FetchRequest(fetchRequest: RecentItem) private var recentItems
    var body: some View {
        List {
            TodaysRecentlyVistiedItems(items: model.todaysItems)
            ItemsVisitedThisMonthView(items: model.thisMonthsItems)
            ItemsVisitedInRecentMonthsView(visitedItems: model.otherMonthItems)
        }.listStyle(.insetGrouped)
    }
}
