import Foundation

@testable import govuk_ios

class MockChatServiceClient: ChatServiceClientInterface {

    var _stubbedAskQuestionResult: ChatQuestionResult?
    func askQuestion(_ question: String,
                     conversationId: String?,
                     completion: @escaping (ChatQuestionResult) -> Void) {
        if let result = _stubbedAskQuestionResult {
            completion(result)
        }
    }

    var _stubbedFetchAnswerResults: [ChatAnswerResult?] = []
    func fetchAnswer(conversationId: String,
                     questionId: String,
                     completion: @escaping (ChatAnswerResult) -> Void) {
        guard !_stubbedFetchAnswerResults.isEmpty else {
            completion(.failure(ChatError.apiUnavailable))
            return
        }
        let nextResult = _stubbedFetchAnswerResults.removeFirst()
        if let nextResult {
            completion(nextResult)
        }
    }

    var _stubbedFetchHistoryResult: ChatHistoryResult?
    func fetchHistory(conversationId: String,
                      completion: @escaping (ChatHistoryResult) -> Void) {
        if let result = _stubbedFetchHistoryResult {
            completion(result)
        }
    }
}
