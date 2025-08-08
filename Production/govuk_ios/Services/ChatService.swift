import Foundation

protocol ChatServiceInterface {
    func askQuestion(_ question: String,
                     completion: @escaping (ChatQuestionResult) -> Void)
    func pollForAnswer(_ pendingQuestion: PendingQuestion,
                       completion: @escaping (ChatAnswerResult) -> Void)
    func chatHistory(conversationId: String,
                     completion: @escaping (ChatHistoryResult) -> Void)
    func clearHistory()

    var currentConversationId: String? { get }
    var isEnabled: Bool { get }
}

final class ChatService: ChatServiceInterface {
    private let serviceClient: ChatServiceClientInterface
    private let chatRepository: ChatRepositoryInterface
    private let configService: AppConfigServiceInterface

    private var pollingInterval: TimeInterval {
        configService.chatPollIntervalSeconds
    }

    var currentConversationId: String? {
        chatRepository.fetchConversation()
    }

    var isEnabled: Bool {
        false
    }


    init(serviceClient: ChatServiceClientInterface,
         chatRepository: ChatRepositoryInterface,
         configService: AppConfigServiceInterface) {
        self.serviceClient = serviceClient
        self.chatRepository = chatRepository
        self.configService = configService
    }

    func askQuestion(_ question: String,
                     completion: @escaping (ChatQuestionResult) -> Void) {
        serviceClient.askQuestion(
            question,
            conversationId: currentConversationId,
            completion: { [weak self] result in
                switch result {
                case .success(let pendingQuestion):
                    self?.setConversationId(pendingQuestion.conversationId)
                    completion(.success(pendingQuestion))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func pollForAnswer(_ pendingQuestion: PendingQuestion,
                       completion: @escaping (ChatAnswerResult) -> Void) {
        serviceClient.fetchAnswer(
            conversationId: pendingQuestion.conversationId,
            questionId: pendingQuestion.id,
            completion: { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let answer):
                    guard answer.answerAvailable else {
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + (self.pollingInterval)
                        ) {
                            self.pollForAnswer(pendingQuestion,
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

    func chatHistory(conversationId: String,
                     completion: @escaping (ChatHistoryResult) -> Void) {
        setConversationId(conversationId)
        serviceClient.fetchHistory(
            conversationId: conversationId,
            completion: { result in
                switch result {
                case .success(let history):
                    completion(.success(history))
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
