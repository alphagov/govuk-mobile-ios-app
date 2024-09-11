import Foundation
import CoreData

@objc(ActivityItem)
class ActivityItem: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
        .init(entityName: "ActivityItem")
    }

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var date: String
    @NSManaged var url: String

    var formattedDate: String {
        let date =  DateHelper.convertDateStringToDate(dateString: date)
        let day = DateHelper.getDay(date: date)
        guard let day = day else { return ""}
        let components = DateHelper.returnCalanderComponent(date: date)
        let month = DateHelper.getMonthName(components: components)
        let dateString = ("Last visited on \(day) \(month)")
        return dateString
    }
}
