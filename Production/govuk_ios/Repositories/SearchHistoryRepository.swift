import Foundation
import CoreData

protocol SearchHistoryRepositoryInterface {
    func save(searchText: String,
              date: Date)
    func delete(_ item: SearchHistoryItem)
    func clearSearchHistory()
    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem> { get }
}

struct SearchHistoryRepository: SearchHistoryRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func save(searchText: String,
              date: Date) {
        let context = coreData.backgroundContext
        let searchHistoryItem = fetch(
            predicate: .init(format: "searchText = %@", searchText),
            context: context
        ).first ?? SearchHistoryItem(context: context)
        searchHistoryItem.searchText = searchText
        searchHistoryItem.date = date
        pruneSearchHistoryItems(context)
        try? context.save()
    }

    func delete(_ item: SearchHistoryItem) {
        let context = item.managedObjectContext
        context?.delete(item)
        try? context?.save()
    }

    func clearSearchHistory() {
        fetch(context: coreData.backgroundContext).forEach {
            coreData.backgroundContext.delete($0)
        }
        try? coreData.backgroundContext.save()
    }

    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem> {
        let fetchRequest = SearchHistoryItem.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: coreData.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        try? controller.performFetch()
        return controller
    }

    private func pruneSearchHistoryItems(_ context: NSManagedObjectContext) {
        let items = fetch(context: context)
        if items.count > 5 {
            items[5...].forEach { context.delete($0) }
        }
    }

    private func fetch(predicate: NSPredicate? = nil,
                       context: NSManagedObjectContext) -> [SearchHistoryItem] {
        let fetchRequest = SearchHistoryItem.fetchRequest()
        fetchRequest.predicate = predicate
        return (try? context.fetch(fetchRequest)) ?? []
    }
}
