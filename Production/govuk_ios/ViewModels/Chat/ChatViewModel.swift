import SwiftUI
import GOVKit
import UIComponents

class ChatViewModel: ObservableObject {
    private let chatService: ChatServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    let maxCharacters = 300
    private let openURLAction: (URL) -> Void
    private let handleError: (ChatError) -> Void
    private var didLoadHistory: Bool = false

    @Published var cellModels: [ChatCellViewModel] = []
    @Published var latestQuestion: String = ""
    @Published var scrollToBottom: Bool = false
    @Published var scrollToTop: Bool = false
    @Published var latestQuestionID: String = ""
    @Published var errorText: String?
    @Published var textViewHeight: CGFloat = 50.0
    @Published var requestInFlight: Bool = false

    init(chatService: ChatServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         openURLAction: @escaping (URL) -> Void,
         handleError: @escaping (ChatError) -> Void) {
        self.chatService = chatService
        self.analyticsService = analyticsService
        self.openURLAction = openURLAction
        self.handleError = handleError
    }

    func askQuestion(_ question: String? = nil,
                     completion: ((Bool) -> Void)? = nil) {
        let localQuestion = question ?? latestQuestion
        guard !containsPII(localQuestion) else {
            errorText = String.chat.localized("validationErrorText")
            completion?(false)
            return
        }
        trackAskQuestionSubmission()
        errorText = nil
        cellModels.append(.loadingQuestion)
        scrollToBottom = true
        requestInFlight = true
        chatService.askQuestion(localQuestion) { [weak self] result in
            self?.requestInFlight = false
            switch result {
            case .success(let pendingQuestion):
                self?.cellModels.removeAll(where: { $0.id == ChatCellViewModel.loadingQuestion.id })
                let cellModel = ChatCellViewModel(question: pendingQuestion)
                self?.cellModels.append(cellModel)
                self?.latestQuestionID = pendingQuestion.id
                self?.latestQuestion = ""
                self?.pollForAnswer(pendingQuestion)
                completion?(true)
            case .failure(let error):
                self?.requestInFlight = false
                if error == .validationError {
                    self?.errorText = String.chat.localized("validationErrorText")
                } else {
                    self?.handleError(error)
                    self?.latestQuestion = ""
                }
                completion?(false)
            }
        }
    }

    private func pollForAnswer(_ question: PendingQuestion) {
        requestInFlight = true
        cellModels.append(.gettingAnswer)
        chatService.pollForAnswer(question) { [weak self] result in
            guard let self else { return }
            cellModels.removeAll(where: { $0.id == ChatCellViewModel.gettingAnswer.id })
            requestInFlight = false
            switch result {
            case .success(let answer):
                let cellModel = ChatCellViewModel(
                    answer: answer,
                    openURLAction: openURLAction,
                    analyticsService: analyticsService
                )
                scrollToTop = true
                cellModels.append(cellModel)
            case .failure(let error):
                handleError(error)
            }
            trackAnswerResponse()
        }
    }

    func loadHistory() {
        guard !didLoadHistory else {
            return
        }
        guard let conversationId = chatService.currentConversationId else {
            cellModels.removeAll()
            appendIntroMessages()
            return
        }
        requestInFlight = true
        chatService.chatHistory(
            conversationId: conversationId
        ) { [weak self] result in
            self?.requestInFlight = false
            switch result {
            case .success(let answers):
                self?.didLoadHistory = true
                self?.handleHistoryResponse(answers)
            case .failure(let error):
                if error == .pageNotFound {
                    self?.chatService.clearHistory()
                } else {
                    self?.handleError(error)
                }
            }
            self?.scrollToBottom = true
        }
    }

    var absoluteRemainingCharacters: Int {
        abs(maxCharacters - latestQuestion.count)
    }

    var shouldDisableSend: Bool {
        latestQuestion.isEmpty ||
        (latestQuestion.count > maxCharacters) ||
        requestInFlight
    }

    var currentConversationExists: Bool {
        chatService.currentConversationId != nil
    }

    private func appendIntroMessages() {
        let firstIntroMessage = Intro(
            title: String.chat.localized("answerTitle"),
            message: String.chat.localized("introFirstMessage")
        )
        let secondIntroMessage = Intro(
            title: nil,
            message: String.chat.localized("introSecondMessage")
        )
        let thirdIntroMessage = Intro(
            title: nil,
            message: String.chat.localized("introThirdMessage")
        )
        cellModels.append(ChatCellViewModel(intro: firstIntroMessage))
        cellModels.append(ChatCellViewModel(intro: secondIntroMessage))
        cellModels.append(ChatCellViewModel(intro: thirdIntroMessage))
    }

    private func handleHistoryResponse(_ history: History) {
        cellModels.removeAll()
        appendIntroMessages()
        let answers = history.answeredQuestions
        answers.forEach { answeredQuestion in
            let question = ChatCellViewModel(answeredQuestion: answeredQuestion)
            cellModels.append(question)
            let answer = ChatCellViewModel(
                answer: answeredQuestion.answer,
                openURLAction: openURLAction,
                analyticsService: analyticsService
            )
            cellModels.append(answer)
        }
        if let pendingQuestion = history.pendingQuestion {
            let question = ChatCellViewModel(question: pendingQuestion)
            cellModels.append(question)
            pollForAnswer(pendingQuestion)
        }
    }

    private func containsPII(_ input: String) -> Bool {
        RegexValidator.pii.validate(input: input)
    }

    @objc
    func newChat() {
        cellModels.removeAll()
        chatService.clearHistory()
        appendIntroMessages()
    }

    func openAboutURL() {
        trackMenuTap(String.chat.localized("aboutMenuTitle"))
        openURLAction(chatService.about)
    }

    func openPrivacyURL() {
        trackMenuTap(String.chat.localized("privacyMenuTitle"))
        openURLAction(chatService.privacyPolicy)
    }

    func openFeedbackURL() {
        trackMenuTap(String.chat.localized("feedbackMenuTitle"))
        openURLAction(chatService.feedback)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    func trackMenuClearChatTap() {
        let event = AppEvent.chatActionButtonFunction(
            text: String.chat.localized("clearMenuTitle"),
            action: "Clear Chat Tapped"
        )
        analyticsService.track(event: event)
    }

    func trackMenuClearChatConfirmTap() {
        let event = AppEvent.chatActionButtonFunction(
            text: String.chat.localized("clearAlertConfirmTitle"),
            action: "Clear Chat Yes Tapped"
        )
        analyticsService.track(event: event)
    }

    func trackMenuClearChatDenyTap() {
        let event = AppEvent.chatActionButtonFunction(
            text: String.chat.localized("clearAlertDenyTitle"),
            action: "Clear Chat No Tapped"
        )
        analyticsService.track(event: event)
    }

    private func trackMenuTap(_ itemTitle: String) {
        let event = AppEvent.buttonNavigation(
            text: itemTitle,
            external: true
        )
        analyticsService.track(event: event)
    }

    private func trackAskQuestionSubmission() {
        let event = AppEvent.chatAskQuestion()
        analyticsService.track(event: event)
    }

    private func trackAnswerResponse() {
        let event = AppEvent.function(
            text: "Chat Question Answer Returned",
            type: "ChatQuestionAnswerReturned",
            section: "Chat",
            action: "Chat Question Answer Returned"
        )
        analyticsService.track(event: event)
    }
}
