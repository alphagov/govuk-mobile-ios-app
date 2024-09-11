import Foundation

struct RecentItemsViewStructure: Equatable {
    let todaysItems: [ActivityItem]
    let thisMonthsItems: [ActivityItem]
    let otherMonthItems: [ActivityItem]
    let listOfOtherItemDateStrings: [String]
}
