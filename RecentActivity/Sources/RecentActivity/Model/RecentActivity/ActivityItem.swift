import Foundation
import CoreData
import GOVKit

@objc(ActivityItem)
public class ActivityItem: NSManagedObject,
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

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var url: String
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
