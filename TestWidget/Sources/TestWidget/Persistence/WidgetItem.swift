import Foundation
import CoreData

@objc(WidgetItem)
public class WidgetItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WidgetItem> {
        let request = NSFetchRequest<WidgetItem>(entityName: "WidgetItem")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return request
    }

    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
}
