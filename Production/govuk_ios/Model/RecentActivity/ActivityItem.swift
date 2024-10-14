import Foundation
import CoreData

@objc(ActivityItem)
class ActivityItem: NSManagedObject,
                    Identifiable,
                    GroupedListRow {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
        let request: NSFetchRequest<ActivityItem> = .init(
            entityName: "ActivityItem"
        )
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \ActivityItem.date,
                ascending: false
            )
        ]
        return request
    }

    @nonobjc public class func clearRequest() -> NSFetchRequest<NSFetchRequestResult> {
        .init(entityName: "ActivityItem")
    }

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var url: String
}

extension ActivityItem {
    @discardableResult
    func update(_ params: ActivityItemCreateParams) -> Self {
        self.id = params.id
        self.title = params.title
        self.date = params.date
        self.url = params.url
        return self
    }
}
