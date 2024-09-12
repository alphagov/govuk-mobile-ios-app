import Foundation
import CoreData

@objc(ActivityItem)
class ActivityItem: NSManagedObject, Identifiable {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
//        .init(entityName: "ActivityItem")
//    }
    private static var fetchRequest: NSFetchRequest<ActivityItem> {
        NSFetchRequest(entityName: "ActivityItem")
    }

    static func all() -> NSFetchRequest<ActivityItem> {
        let request: NSFetchRequest<ActivityItem> = fetchRequest
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ActivityItem.title, ascending: true)]
        return request
    }

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var url: String

    var formattedDate: String {
       // let date =  DateHelper.convertDateStringToDate(dateString: date)
        let day = DateHelper.getDay(date: date)
        guard let day = day else { return ""}
        let components = DateHelper.returnCalanderComponent(date: date)
        let month = DateHelper.getMonthName(components: components)
        let dateString = ("Last visited on \(day) \(month)")
        return dateString
    }
}
