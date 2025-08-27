import Foundation

protocol ChatServiceInterface {
    func askQuestion(_ question: String,
                     completion: @escaping (ChatQuestionResult) -> Void)
    func pollForAnswer(_ pendingQuestion: PendingQuestion,
                       completion: @escaping (ChatAnswerResult) -> Void)
    func chatHistory(conversationId: String,
                     completion: @escaping (ChatHistoryResult) -> Void)
    func clearHistory()
    func setChatOnboarded()
    func setChatOptedIn(_ optedIn: Bool)

    var retryAction: (() -> Void)? { get }
    var isRetryAction: Bool { get }
    var chatOnboardingSeen: Bool { get }
    var chatOptedIn: Any? { get }
    var currentConversationId: String? { get }
    var isEnabled: Bool { get }
}

final class ChatService: ChatServiceInterface {
    private let serviceClient: ChatServiceClientInterface
    private let chatRepository: ChatRepositoryInterface
    private let configService: AppConfigServiceInterface
    private let userDefaultsService: UserDefaultsServiceInterface

    private(set) var retryAction: (() -> Void)?
    private(set) var isRetryAction: Bool = false
    private var pollingInterval: TimeInterval {
        configService.chatPollIntervalSeconds
    }

    var currentConversationId: String? {
        chatRepository.fetchConversation()
    }

    var isEnabled: Bool {
        false
    }

    var chatOnboardingSeen: Bool {
        userDefaultsService.bool(forKey: .chatOnboardingSeen)
    }

    var chatOptedIn: Any? {
        userDefaultsService.value(forKey: .chatOptedIn)
    }

    init(serviceClient: ChatServiceClientInterface,
         chatRepository: ChatRepositoryInterface,
         configService: AppConfigServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface) {
        self.serviceClient = serviceClient
        self.chatRepository = chatRepository
        self.configService = configService
        self.userDefaultsService = userDefaultsService
    }

    func setChatOnboarded() {
        userDefaultsService.set(bool: true, forKey: .chatOnboardingSeen)
    }

    func setChatOptedIn(_ optedIn: Bool) {
        userDefaultsService.set(bool: optedIn, forKey: .chatOptedIn)
    }

    func askQuestion(_ question: String,
                     completion: @escaping (ChatQuestionResult) -> Void) {
        retryAction = {
            self.isRetryAction = true
            self.askQuestion(question,
                             completion: completion)
        }
        serviceClient.askQuestion(
            question,
            conversationId: currentConversationId,
            completion: { [weak self] result in
                switch result {
                case .success(let pendingQuestion):
                    self?.isRetryAction = false
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
        retryAction = {
            self.isRetryAction = true
            self.pollForAnswer(pendingQuestion,
                             completion: completion)
        }
        serviceClient.fetchAnswer(
            conversationId: pendingQuestion.conversationId,
            questionId: pendingQuestion.id,
            completion: { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let answer):
                    isRetryAction = false
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
        retryAction = {
            self.isRetryAction = true
            self.chatHistory(conversationId: conversationId,
                             completion: completion)
        }
        serviceClient.fetchHistory(
            conversationId: conversationId,
            completion: { [weak self] result in
                switch result {
                case .success(let history):
                    self?.isRetryAction = false
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
