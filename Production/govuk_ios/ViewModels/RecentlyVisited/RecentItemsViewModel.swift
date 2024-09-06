import Foundation
import CoreData
import SwiftUI

class RecentItemsViewModel: ObservableObject {
    @Published var state = State.loading
    private let service: RecentItemsServiceInterface
    private let activityRepository: ActivityRepository
    @FetchRequest(fetchRequest: ActivityItem.fetchRequest()) var recentItems

    init(service: RecentItemsServiceInterface,
         activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
        self.service = service
        fetchViewdItems()
    }

    enum State: Equatable {
        case loading
        case loaded(RecentItemsViewStructure)
        case error(RecentItemsErrorStructure)
    }
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

   func sortItems(visitedItems: [[RecentItem]]) -> ([RecentItem],
         [RecentItem],
        [[RecentItem]]) {
        let todaysDate = Date()
        var todaysItems: [RecentItem]  = []
        var currentMonthItems: [RecentItem]  = []
        var listOfOtherItems = [[RecentItem]]()
        for vistiedItem in visitedItems {
            if let item = vistiedItem.first {
                let itemDate = DateHelper.convertDateStringToDate(
                    dateString: item.date)
                if DateHelper.checkDatesAreTheSame(dateOne: itemDate,
                                                   dateTwo: todaysDate) {
                    todaysItems = vistiedItem
                } else if DateHelper.checkEqualityOfMonthAndYear(
                    dateOne: DateHelper.convertDateStringToDate(
                    dateString: item.date),
                    dateTwo: todaysDate) {
                    currentMonthItems.append(item)
                } else {
                    listOfOtherItems.append(vistiedItem)
                }
            }
        }
        return (todaysItems, currentMonthItems, listOfOtherItems)
    }

    private func fetchViewdItems() {
        service.fetchItems { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let visitedItems):
                let components = self.sortItems(
                    visitedItems: visitedItems)
                self.state = .loaded(RecentItemsViewStructure(
                    todaysItems: components.0,
                    thisMonthsItems: components.1,
                    otherMonthItems: components.2
                )
                )
            case .failure(let error):
                self.state = .error(RecentItemsErrorStructure(
                    errorTitle: error.errorDescription.0,
                    errrorDesc: error.errorDescription.1
                )
                )
            }
        }
    }
}
