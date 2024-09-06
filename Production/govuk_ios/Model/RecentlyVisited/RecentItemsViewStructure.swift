import Foundation

struct RecentItemsViewStructure: Equatable {
    let todaysItems: [RecentItem]
    let thisMonthsItems: [RecentItem]
    let otherMonthItems: [[RecentItem]]
}
