import Foundation
import CoreData

@objc(LocalAuthorityItem)
class LocalAuthorityItem: NSManagedObject,
                          Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalAuthorityItem> {
        return NSFetchRequest<LocalAuthorityItem>(entityName: "LocalAuthorityItem")
    }

    @NSManaged public var name: String
    @NSManaged public var homepageUrl: String
    @NSManaged public var tier: String
    @NSManaged public var slug: String
    @NSManaged public var parent: LocalAuthorityItem?
}

extension LocalAuthorityItem {
    func update(with authority: Authority) {
        name = authority.name
        homepageUrl = authority.homepageUrl
        slug = authority.slug
        tier = authority.tier
    }
}
