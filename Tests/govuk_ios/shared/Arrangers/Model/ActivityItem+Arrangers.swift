import Foundation
import CoreData
import RecentActivity

@testable import govuk_ios

extension ActivityItem {
    static func arrange(id: String = UUID().uuidString,
                        title: String = UUID().uuidString,
                        date: Date = .init(),
                        url: String = "https://www.gov.uk",
                        context: NSManagedObjectContext) -> ActivityItem {
        let item = ActivityItem(context: context)
        item.id = id
        item.title = title
        item.date = date
        item.url = url
        return item
    }
}
