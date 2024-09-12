import Foundation
import CoreData
import SwiftUI

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

    func sortItems(visitedItems: FetchedResults<ActivityItem>) -> RecentItemsViewStructure {
        var todaysItems: [ActivityItem]  = []
        var currentMonthItems: [ActivityItem]  = []
        var itemsBelongToOtherMonths: [ActivityItem] = []
        var listOfMonthAndYears: [String] = []
        let todaysDate = Date()
        var itemsToBeSorted: [ActivityItem] = visitedItems.map { $0 }
        DateHelper.sortDate(dates: &itemsToBeSorted)
        for visitedItem in itemsToBeSorted {
//            let itemDate = DateHelper.convertDateStringToDate(dateString: vistiedItem.date)
            if DateHelper.checkDatesAreTheSame(dateOne: visitedItem.date, dateTwo: todaysDate) {
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
                listOfOtherItemDateStrings: listOfMonthAndYears)
        }
    }
