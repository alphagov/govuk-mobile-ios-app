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

    var chatOnboardingSeen: Bool { get }
    var currentConversationId: String? { get }
    var isEnabled: Bool { get }
}

final class ChatService: ChatServiceInterface {
    private let serviceClient: ChatServiceClientInterface
    private let chatRepository: ChatRepositoryInterface
    private let configService: AppConfigServiceInterface
    private let userDefaultsService: UserDefaultsServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let maxAuthRetryCount = 1
    private var authRetryCount = 0

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

    init(serviceClient: ChatServiceClientInterface,
         chatRepository: ChatRepositoryInterface,
         configService: AppConfigServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface,
         authenticationService: AuthenticationServiceInterface) {
        self.serviceClient = serviceClient
        self.chatRepository = chatRepository
        self.configService = configService
        self.userDefaultsService = userDefaultsService
        self.authenticationService = authenticationService
    }

    func setChatOnboarded() {
        userDefaultsService.set(bool: true, forKey: .chatOnboardingSeen)
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
                    if case .authenticationError = error {
                        Task { [weak self] in
                            guard let self = self else { return }
                            await self.refreshAndRetry(
                                {
                                    self.askQuestion(question,
                                                     completion: completion)
                                },
                                completion: completion
                            )
                        }
                    }
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
                    if case .authenticationError = error {
                        Task { [weak self] in
                            guard let self = self else { return }
                            await self.refreshAndRetry(
                                {
                                    self.pollForAnswer(pendingQuestion,
                                                       completion: completion)
                                },
                                completion: completion
                            )
                        }
                        return
                    }
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
                    if case .authenticationError = error {
                        Task { [weak self] in
                            guard let self = self else { return }
                            await self.refreshAndRetry(
                                {
                                    self.chatHistory(conversationId: conversationId,
                                                     completion: completion)
                                },
                                completion: completion
                            )
                        }
                        return
                    }
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

    private func refreshAndRetry<T: Codable>(
        _ retryRequest: (() -> Void),
        completion: @escaping (Result<T, ChatError>
        ) -> Void) async {
        guard authRetryCount < maxAuthRetryCount else {
            Task { @MainActor in
                completion(.failure(.apiUnavailable))
            }
            return
        }
        let refreshResult = await authenticationService.tokenRefreshRequest()
        switch refreshResult {
        case .success:
            retryRequest()
        case .failure:
            Task { @MainActor in
                completion(.failure(.apiUnavailable))
            }
        }
        authRetryCount += 1
    }
}
