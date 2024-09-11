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
        for vistiedItem in itemsToBeSorted {
            let itemDate = DateHelper.convertDateStringToDate(dateString: vistiedItem.date)
            if DateHelper.checkDatesAreTheSame(dateOne: itemDate, dateTwo: todaysDate) {
                todaysItems.append(vistiedItem)
            } else if DateHelper.checkEqualityOfMonthAndYear(
                dateOne: DateHelper.convertDateStringToDate(
                    dateString: vistiedItem.date),
                dateTwo: todaysDate) {
                currentMonthItems.append(vistiedItem)
            } else {
                listOfMonthAndYears.append(DateHelper.getMonthAndYear(date: itemDate))
                itemsBelongToOtherMonths.append(vistiedItem)
            }
        }
            return RecentItemsViewStructure(
                todaysItems: todaysItems,
                thisMonthsItems: currentMonthItems,
                otherMonthItems: itemsBelongToOtherMonths,
                listOfOtherItemDateStrings: listOfMonthAndYears)
        }
    }
