import Foundation

@testable import govuk_ios

final class MockChatRespository: ChatRepositoryInterface {
    var _didSaveConversation = false
    var _conversationId: String?
    func saveConversation(_ conversationId: String?) {
        _didSaveConversation = true
        _conversationId = conversationId
    }

    func fetchConversation() -> String? {
        _conversationId
    }
}
