import Foundation
import UIKit
import CoreData
import GOVKit

protocol SearchHistoryViewModelInterface {
    var analyticsService: AnalyticsServiceInterface { get }
    var searchHistoryItems: [SearchHistoryItem] { get }

    func saveSearchHistoryItem(searchText: String,
                               date: Date)
    func clearSearchHistory()
    func delete(_ item: SearchHistoryItem)
}

class SearchHistoryViewModel: NSObject,
                              SearchHistoryViewModelInterface {
    private let searchService: SearchServiceInterface
    let analyticsService: AnalyticsServiceInterface
    var searchHistoryItems = [SearchHistoryItem]()

    private lazy var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem>? = {
        let localController = searchService.fetchedResultsController
        localController?.delegate = self
        return localController
    }()

    init(searchService: SearchServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.searchService = searchService
        self.analyticsService = analyticsService
        super.init()
        searchHistoryItems = fetchedResultsController?.fetchedObjects ?? []
    }

    func saveSearchHistoryItem(searchText: String,
                               date: Date) {
        searchService.save(searchText: searchText, date: date)
    }

    func clearSearchHistory() {
        searchService.clearSearchHistory()
    }

    func delete(_ item: SearchHistoryItem) {
        searchService.delete(item)
    }
}

extension SearchHistoryViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChangeContentWith
                    snapshot: NSDiffableDataSourceSnapshotReference) {
        searchHistoryItems = fetchedResultsController?.fetchedObjects ?? []
    }
}
