import Foundation
import CoreData

@objc(ActivityItem)
class ActivityItem: NSManagedObject, Identifiable, GroupedListRow {
    private static var fetchRequest: NSFetchRequest<ActivityItem> {
        NSFetchRequest(entityName: "ActivityItem")
    }

    static func all() -> NSFetchRequest<ActivityItem> {
        let request: NSFetchRequest<ActivityItem> = fetchRequest
        request.sortDescriptors = [NSSortDescriptor(
            keyPath: \ActivityItem.date,
            ascending: false)]
        return request
    }

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var url: String

    var formattedDate: String {
        let day = DateHelper.getDay(date: date)
        guard let day = day else { return ""}
        let components = DateHelper.returnCalanderComponent(date: date)
        let month = DateHelper.getMonthName(components: components)
        let dateString = ("\(formattedString) \(day) \(month)")
        return dateString
    }

    private var formattedString: String {
        "activityItemformattedDateStringComponent".localized
    }
}
