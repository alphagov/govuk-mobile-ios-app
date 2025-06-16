import Foundation
import GOVKit

typealias ChatQuestionResult = (Result<PendingQuestion, Error>)
typealias ChatAnswerResult = (Result<Answer, Error>)
typealias ChatHistoryResult = (Result<History, Error>)

protocol ChatServiceClientInterface {
    func askQuestion(_ question: String,
                     conversationId: String?,
                     completion: @escaping (ChatQuestionResult) -> Void)
    func fetchAnswer(conversationId: String,
                     questionId: String,
                     completion: @escaping (ChatAnswerResult) -> Void)
    func fetchHistory(conversationId: String,
                      completion: @escaping (ChatHistoryResult) -> Void)
}

enum ChatError: LocalizedError {
    case networkUnavailable
    case apiUnavailable
    case decodingError
    case validationError
    case maxRetriesExceeded
}

struct ChatServiceClient: ChatServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func askQuestion(_ question: String,
                     conversationId: String?,
                     completion: @escaping (ChatQuestionResult) -> Void) {
        let request = GOVRequest.askQuestion(
            question,
            conversationId: conversationId
        )
        serviceClient.send(request: request) {
            completion(mapResult($0))
        }
    }

    func fetchAnswer(conversationId: String,
                     questionId: String,
                     completion: @escaping (ChatAnswerResult) -> Void) {
        let request = GOVRequest.getAnswer(
            conversationId: conversationId,
            questionId: questionId
        )
        serviceClient.send(request: request) {
            completion(mapResult($0))
        }
    }

    func fetchHistory(conversationId: String,
                      completion: @escaping (ChatHistoryResult) -> Void) {
        let request = GOVRequest.getChatHistory(conversationId: conversationId)
        serviceClient.send(request: request) {
            completion(mapResult($0))
        }
    }

    private func mapResult<T: Decodable>(_ result: NetworkResult<Data>) -> Result<T, Error> {
        return result.mapError { error in
            let nsError = (error as NSError)
            if nsError.code == NSURLErrorNotConnectedToInternet {
                return ChatError.networkUnavailable
            } else {
                return (error as? ChatError) ?? ChatError.apiUnavailable
            }
        }.flatMap {
            let decoder = JSONDecoder()
            do {
            let response = try decoder.decode(T.self, from: $0)
                return .success(response)
            } catch {
                print(error)
                return .failure(ChatError.decodingError)
            }
        }
    }
}
