import Foundation
import Testing
import CoreData

@testable import govuk_ios

struct ChatRespositoryTests {

    @Test
    func save_chatItem_savesConversationId() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ChatRepository(coreData: coreData)
        let expectedConversationId = "conversation_id"

        sut.saveConversation(expectedConversationId)

        var results: [ChatItem] = []
        coreData.backgroundContext.performAndWait {
            let fetchRequest = ChatItem.fetchRequest()
            results = (try? coreData.backgroundContext.fetch(fetchRequest)) ?? []
        }

        #expect(results.count == 1)
        #expect(results.first?.conversationId == expectedConversationId)
    }

    @Test
    func save_chatItem_savesOnlyOneConversationId() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ChatRepository(coreData: coreData)
        let expectedConversationId = "conversation_id"
        let secondExpectedConversationId = "second_conversation_id"

        sut.saveConversation(expectedConversationId)
        sut.saveConversation(secondExpectedConversationId)

        var results: [ChatItem] = []
        coreData.backgroundContext.performAndWait {
            let fetchRequest = ChatItem.fetchRequest()
            results = (try? coreData.backgroundContext.fetch(fetchRequest)) ?? []
        }

        #expect(results.count == 1)
        #expect(results.first?.conversationId == secondExpectedConversationId)
    }

    @Test
    func save_chatItem_savesNilConversationId() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ChatRepository(coreData: coreData)

        sut.saveConversation(nil)

        var results: [ChatItem] = []
        coreData.backgroundContext.performAndWait {
            let fetchRequest = ChatItem.fetchRequest()
            results = (try? coreData.backgroundContext.fetch(fetchRequest)) ?? []
        }

        #expect(results.count == 1)
        #expect(results.first?.conversationId == nil)
    }

    @Test
    func fetchConversation_fetchesExpectedItem() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = ChatRepository(coreData: coreData)
        let expectedConversationId = "conversation_id"

        let context = coreData.backgroundContext
        let chatItem = ChatItem(context: context)
        chatItem.conversationId = expectedConversationId
        context.performAndWait {
            try? context.save()
        }

        let conversationId = sut.fetchConversation()
        #expect(conversationId == expectedConversationId)
    }
}
