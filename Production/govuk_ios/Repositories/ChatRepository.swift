import Foundation
import CoreData
import GOVKit

protocol ChatRepositoryInterface {
    func saveConversation(_ conversationId: String?)
    func fetchConversation() -> String?
}

struct ChatRepository: ChatRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func saveConversation(_ conversationId: String?) {
        let context = coreData.backgroundContext
        let request = ChatItem.fetchRequest()
        context.performAndWait {
            let chatItem = try? context.fetch(request).first ?? ChatItem(context: context)
            chatItem?.conversationId = conversationId
            try? context.save()
        }
    }

    func fetchConversation() -> String? {
        let context = coreData.backgroundContext
        return context.performAndWait {
            if let chatItem = try? context.fetch(ChatItem.fetchRequest()).first {
                return chatItem.conversationId
            }
            return nil
        }
    }
}
