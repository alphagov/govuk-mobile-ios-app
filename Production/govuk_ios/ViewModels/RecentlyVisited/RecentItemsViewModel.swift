import Foundation
import CoreData
import SwiftUI
import UIKit

class RecentItemsViewModel: ObservableObject {
    let navigationTitle = NSLocalizedString(
        "Pages You've visited",
        bundle: .main,
        comment: ""
    )
    let toolbarTitle = NSLocalizedString(
        "editButtonTitle",
        bundle: .main,
        comment: ""
    )

    func itemSelected(item: ActivityItem) {
        item.date = Date()
        do {
            try item.managedObjectContext?.save()
        } catch {
        }
        guard let url = URL(string: item.url) else { return }
        UIApplication.shared.open(url)
    }

    func sortItems(visitedItems: FetchedResults<ActivityItem>) -> RecentItemsViewStructure {
        var todaysItems: [ActivityItem]  = []
        var currentMonthItems: [ActivityItem]  = []
        var itemsBelongToOtherMonths: [ActivityItem] = []
        var listOfMonthAndYears: [String] = []
        let todaysDate = Date()
        var itemsToBeSorted: [ActivityItem] = visitedItems.map { $0 }
        DateHelper.sortDate(dates: &itemsToBeSorted)

        for visitedItem in itemsToBeSorted {
            if DateHelper.checkDatesAreTheSame(dateOne: visitedItem.date,
                                               dateTwo: todaysDate) {
                todaysItems.append(visitedItem)
            } else if DateHelper.checkEqualityOfMonthAndYear(
                dateOne: visitedItem.date,
                dateTwo: todaysDate) {
                currentMonthItems.append(visitedItem)
            } else {
                listOfMonthAndYears.append(DateHelper.getMonthAndYear(date: visitedItem.date))
                itemsBelongToOtherMonths.append(visitedItem)
            }
        }
            return RecentItemsViewStructure(
                todaysItems: todaysItems,
                thisMonthsItems: currentMonthItems,
                otherMonthItems: itemsBelongToOtherMonths,
                listOfOtherItemDateStrings: removeDuplicateStrings(arr: listOfMonthAndYears))
        }

    func removeDuplicateStrings(arr: [String]) -> [String] {
        var uniqueElements: [String] = []
        for item in arr where !uniqueElements.contains(item) {
                uniqueElements.append(item)
            }
        return uniqueElements
        }
    }
