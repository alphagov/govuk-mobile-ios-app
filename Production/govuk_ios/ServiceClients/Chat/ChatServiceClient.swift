import Foundation
import GOVKit

typealias ChatQuestionResult = (Result<PendingQuestion, ChatError>)
typealias ChatAnswerResult = (Result<Answer, ChatError>)
typealias ChatHistoryResult = (Result<History, ChatError>)

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
    case pageNotFound
    case apiUnavailable
    case decodingError
    case validationError
    case authenticationError
}

struct ChatServiceClient: ChatServiceClientInterface {
    private let serviceClient: APIServiceClientInterface
    private let authenticationService: AuthenticationServiceInterface

    init(serviceClient: APIServiceClientInterface,
         authenticationService: AuthenticationServiceInterface) {
        self.serviceClient = serviceClient
        self.authenticationService = authenticationService
    }

    func askQuestion(_ question: String,
                     conversationId: String?,
                     completion: @escaping (ChatQuestionResult) -> Void) {
        let request = GOVRequest.askQuestion(
            question,
            conversationId: conversationId,
            accessToken: authenticationService.accessToken
        )
        serviceClient.send(
            request: request,
            completion: {
                completion(mapResult($0))
            }
        )
    }

    func fetchAnswer(conversationId: String,
                     questionId: String,
                     completion: @escaping (ChatAnswerResult) -> Void) {
        let request = GOVRequest.getAnswer(
            conversationId: conversationId,
            questionId: questionId,
            accessToken: authenticationService.accessToken
        )
        serviceClient.send(
            request: request,
            completion: {
                completion(mapResult($0))
            }
        )
    }

    func fetchHistory(conversationId: String,
                      completion: @escaping (ChatHistoryResult) -> Void) {
        let request = GOVRequest.getChatHistory(
            conversationId: conversationId,
            accessToken: authenticationService.accessToken
        )
        serviceClient.send(
            request: request,
            completion: {
                completion(mapResult($0))
            }
        )
    }

    private func mapResult<T: Decodable>(_ result: NetworkResult<Data>) -> Result<T, ChatError> {
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
                return .failure(ChatError.decodingError)
            }
        }
    }
}
