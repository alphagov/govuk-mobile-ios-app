import Foundation
import CoreData

struct RecentActivitySection: Hashable {
    let title: String
    let items: [NSManagedObjectID]
}
