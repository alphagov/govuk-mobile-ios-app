import Foundation
import CoreData

protocol SearchHistoryRepositoryInterface {
    func save(searchText: String,
              date: Date) -> SearchHistoryItem
    func fetchAll() -> [SearchHistoryItem]
}

struct SearchHistoryRepository: SearchHistoryRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func fetchAll() -> [SearchHistoryItem] {
        return fetch()
    }

    @discardableResult
    func save(searchText: String,
              date: Date) -> SearchHistoryItem {
        let context = coreData.backgroundContext
        let searchHistoryItem = fetch(
            predicate: .init(format: "searchText = %@", searchText),
            context: context
        ).first ?? SearchHistoryItem(context: context)
        searchHistoryItem.searchText = searchText
        searchHistoryItem.date = date
        pruneSearchHistoryItems(context)
        try? context.save()
        return searchHistoryItem
    }

    private func pruneSearchHistoryItems(_ context: NSManagedObjectContext) {
        let items = fetch(context: context)
        if items.count > 5 {
            items[5...].forEach { context.delete($0) }
        }
    }

    private func fetch(predicate: NSPredicate? = nil,
                       context: NSManagedObjectContext? = nil) -> [SearchHistoryItem] {
        let fetchContext = context ?? coreData.viewContext
        let fetchRequest = SearchHistoryItem.fetchRequest()
        fetchRequest.predicate = predicate
        return (try? fetchContext.fetch(fetchRequest)) ?? []
    }
}
