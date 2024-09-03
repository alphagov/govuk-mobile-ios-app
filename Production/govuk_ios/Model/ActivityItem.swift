import Foundation
import CoreData

@objc(ActivityItem)
class ActivityItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
        .init(entityName: "ActivityItem")
    }

    @NSManaged var id: String
}
