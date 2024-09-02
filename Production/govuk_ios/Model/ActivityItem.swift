import Foundation
import CoreData

@objc(Apiary)
class ActivityItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
        .init(entityName: "ActivityItem")
    }

    @NSManaged var id: String
}
