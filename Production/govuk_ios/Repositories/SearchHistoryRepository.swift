import Foundation
import CoreData
import GOVKit

protocol SearchHistoryRepositoryInterface {
    func save(searchText: String,
              date: Date)
    func delete(_ item: SearchHistoryItem)
    func clearSearchHistory()
    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem>? { get }
    func historyItem(for objectId: NSManagedObjectID) throws -> SearchHistoryItem?
}

struct SearchHistoryRepository: SearchHistoryRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func save(searchText: String,
              date: Date) {
        let context = coreData.backgroundContext
        context.performAndWait {
            let searchHistoryItem = fetch(
                predicate: .init(format: "searchText = %@", searchText),
                context: context
            ).first ?? SearchHistoryItem(context: context)
            searchHistoryItem.searchText = searchText
            searchHistoryItem.date = date
            pruneSearchHistoryItems(context)
            try? context.save()
        }
    }

    func delete(_ item: SearchHistoryItem) {
        let context = item.managedObjectContext
        context?.delete(item)
        try? context?.save()
    }

    func clearSearchHistory() {
        let context = coreData.backgroundContext
        context.performAndWait {
            fetch(context: coreData.backgroundContext).forEach {
                coreData.backgroundContext.delete($0)
            }
            try? coreData.backgroundContext.save()
        }
    }

    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem>? {
        let fetchRequest = SearchHistoryItem.fetchRequest()
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: coreData.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        try? controller.performFetch()
        return controller
    }

    func historyItem(for objectId: NSManagedObjectID) throws -> SearchHistoryItem? {
        try coreData.viewContext.existingObject(with: objectId) as? SearchHistoryItem
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
