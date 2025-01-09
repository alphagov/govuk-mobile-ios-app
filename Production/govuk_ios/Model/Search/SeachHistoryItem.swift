import Foundation
import CoreData

@objc(SearchHistoryItem)
class SearchHistoryItem: NSManagedObject,
                         Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistoryItem> {
        let request: NSFetchRequest<SearchHistoryItem> = .init(
            entityName: "SearchHistoryItem"
        )
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \SearchHistoryItem.date,
                ascending: false
            )
        ]
        return request
    }

    @NSManaged public var searchText: String?
    @NSManaged public var date: Date?

    func update(searchText: String,
                date: Date) {
        self.searchText = searchText
        self.date = date
    }
}
