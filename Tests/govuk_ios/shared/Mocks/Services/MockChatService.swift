import Foundation

@testable import govuk_ios

final class MockChatService: ChatServiceInterface {
    func setChatOnboarded() {
        _stubbedChatOnboardingSeen = true
    }
    
    var _stubbedChatOnboardingSeen = false
    var chatOnboardingSeen: Bool {
        _stubbedChatOnboardingSeen
    }

    var _stubbedIsEnabled = true
    var isEnabled: Bool {
        _stubbedIsEnabled
    }

    var _stubbedQuestionResult: ChatQuestionResult?
    func askQuestion(_ question: String,
                     completion: @escaping (ChatQuestionResult) -> Void) {
        guard let result = _stubbedQuestionResult else {
            return completion(.failure(ChatError.apiUnavailable))
        }
        completion(result)
    }

    var _stubbedAnswerResults: [ChatAnswerResult] = []
    func pollForAnswer(_ pendingQuestion: PendingQuestion,
                       completion: @escaping (ChatAnswerResult) -> Void) {
        guard let result = nextResult() else {
            return completion(.failure(ChatError.apiUnavailable))
        }
        completion(result)
    }

    private func nextResult() -> ChatAnswerResult? {
        guard _stubbedAnswerResults.count > 0 else { return nil }
        return _stubbedAnswerResults.removeFirst()
    }

    var _stubbedHistoryResult: ChatHistoryResult?
    func chatHistory(conversationId: String,
                     completion: @escaping (ChatHistoryResult) -> Void) {
        guard let result = _stubbedHistoryResult else {
            return completion(.failure(ChatError.apiUnavailable))
        }
        completion(result)
    }

    var _clearHistoryCalled = false
    func clearHistory() {
        _clearHistoryCalled = true
        _stubbedConversationId = nil
    }

    var _stubbedConversationId: String?
    var currentConversationId: String? {
        _stubbedConversationId
    }
}
