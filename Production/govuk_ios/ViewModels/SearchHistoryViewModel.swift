import Foundation
import UIKit
import CoreData

class SearchHistoryViewModel: NSObject {
    private let searchService: SearchServiceInterface
    var searchHistoryItems = [SearchHistoryItem]()

    lazy var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem> = {
        let localController = searchService.fetchedResultsController
        localController.delegate = self
        return localController
    }()

    init(searchService: SearchServiceInterface) {
        self.searchService = searchService
        super.init()
        searchHistoryItems = fetchedResultsController.fetchedObjects ?? []
    }

    func saveSearchHistoryItem(searchText: String,
                               date: Date) {
        searchService.save(searchText: searchText, date: date)
    }
}

extension SearchHistoryViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChangeContentWith
                    snapshot: NSDiffableDataSourceSnapshotReference) {
        searchHistoryItems = fetchedResultsController.fetchedObjects ?? []
    }
}
