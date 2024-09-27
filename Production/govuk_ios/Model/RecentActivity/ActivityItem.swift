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

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var url: String
}
