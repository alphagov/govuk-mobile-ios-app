import Foundation

@testable import govuk_ios

final class MockChatService: ChatServiceInterface {
    var _stubbedIsEnabled = true
    var isEnabled: Bool {
        _stubbedIsEnabled
    }

    var _stubbedAnswerResult: ChatAnswerResult?
    func askQuestion(_ question: String,
                     completion: @escaping (ChatAnswerResult) -> Void) {
        guard let result = _stubbedAnswerResult else {
            return completion(.failure(ChatError.apiUnavailable))
        }
        completion(result)
    }

    var _stubbedHistoryResult: Result<[AnsweredQuestion], Error>?
    func chatHistory(conversationId: String?,
                     completion: @escaping (Result<[AnsweredQuestion], Error>) -> Void) {
        guard let result = _stubbedHistoryResult else {
            return completion(.failure(ChatError.apiUnavailable))
        }
        completion(result)
    }

    var _clearHistoryCalled = false
    func clearHistory() {
        _clearHistoryCalled = true
    }

    var _stubbedConversationId: String?
    var currentConversationId:String? {
        _stubbedConversationId
    }

}
