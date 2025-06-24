import Foundation
import CoreData

@objc(ChatItem)
class ChatItem: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatItem> {
        NSFetchRequest<ChatItem>(entityName: "ChatItem")
    }

    @NSManaged public var conversationId: String?
}
