import Foundation
import CoreData

@testable import govuk_ios

extension Topic {
    static func arrange(ref: String = UUID().uuidString,
                        title: String = UUID().uuidString,
                        isFavourite: Bool = true,
                        context: NSManagedObjectContext) -> Topic {
        let item = Topic(context: context)
        item.title = title
        item.isFavorite = isFavourite
        item.ref = ref
        return item
    }
}

