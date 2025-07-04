import Foundation

protocol ChatServiceInterface {
    func askQuestion(_ question: String,
                     completion: @escaping (ChatAnswerResult) -> Void)
    func chatHistory(conversationId: String?,
                     completion: @escaping (Result<[AnsweredQuestion], Error>) -> Void)
    func clearHistory()
    var currentConversationId: String? { get }
}

final class ChatService: ChatServiceInterface {
    private let serviceClient: ChatServiceClientInterface
    private let chatRepository: ChatRepositoryInterface
    private let maxRetryCount: Int
    private let retryInterval: TimeInterval
    var currentConversationId: String? {
        chatRepository.fetchConversation()
    }

    init(serviceClient: ChatServiceClientInterface,
         chatRepository: ChatRepositoryInterface,
         maxRetryCount: Int = 10,
         retryInterval: TimeInterval = 6.0) {
        self.serviceClient = serviceClient
        self.chatRepository = chatRepository
        self.maxRetryCount = maxRetryCount
        self.retryInterval = retryInterval
    }

    func askQuestion(_ question: String,
                     completion: @escaping (ChatAnswerResult) -> Void) {
        serviceClient.askQuestion(
            question,
            conversationId: currentConversationId,
            completion: { [weak self] result in
                switch result {
                case .success(let pendingQuestion):
                    self?.setConversationId(pendingQuestion.conversationId)
                    self?.pollForAnswer(pendingQuestion,
                                        retryCount: 0,
                                        completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    private func pollForAnswer(_ pendingQuestion: PendingQuestion,
                               retryCount: Int,
                               completion: @escaping (Result<Answer, Error>) -> Void) {
        guard retryCount < maxRetryCount else {
            completion(.failure(ChatError.maxRetriesExceeded))
            return
        }
        serviceClient.fetchAnswer(
            conversationId: pendingQuestion.conversationId,
            questionId: pendingQuestion.id,
            completion: { [weak self] result in
                switch result {
                case .success(let answer):
                    guard answer.answerAvailable else {
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + (self?.retryInterval ?? 3.0)
                        ) {
                            self?.pollForAnswer(pendingQuestion,
                                                retryCount: retryCount + 1,
                                                completion: completion)
                        }
                        return
                    }
                    completion(.success(answer))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func chatHistory(conversationId: String?,
                     completion: @escaping (Result<[AnsweredQuestion], Error>) -> Void) {
        guard let conversationId else {
            return completion(.success([]))
        }
        setConversationId(conversationId)
        serviceClient.fetchHistory(
            conversationId: conversationId,
            completion: { result in
                switch result {
                case .success(let history):
                    completion(.success(history.answeredQuestions))
                case .failure(let error):
                    completion(.failure(error))
                }
        })
    }

    func clearHistory() {
        setConversationId(nil)
    }

    private func setConversationId(_ conversationId: String?) {
        guard conversationId != currentConversationId else { return }
        chatRepository.saveConversation(conversationId)
    }
}
