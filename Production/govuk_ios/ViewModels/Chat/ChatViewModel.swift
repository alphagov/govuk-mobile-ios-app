import SwiftUI
import GOVKit
import UIComponents

class ChatViewModel: ObservableObject {
    private let chatService: ChatServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    let maxCharacters = 300
    private let openURLAction: (URL) -> Void
    private let handleError: (Error) -> Void

    @Published var cellModels: [ChatCellViewModel] = []
    @Published var latestQuestion: String = ""
    @Published var scrollToBottom: Bool = false
    @Published var answeredQuestionID: String = ""

    init(chatService: ChatServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         openURLAction: @escaping (URL) -> Void,
         handleError: @escaping (Error) -> Void) {
        self.chatService = chatService
        self.analyticsService = analyticsService
        self.openURLAction = openURLAction
        self.handleError = handleError
    }

    func askQuestion(_ question: String? = nil) {
        cellModels.append(.loadingQuestion)
        scrollToBottom = true
        chatService.askQuestion(question ?? latestQuestion) { [weak self] result in
            self?.cellModels.removeLast()
            switch result {
            case .success(let pendingQuestion):
                let cellModel = ChatCellViewModel(question: pendingQuestion)
                self?.cellModels.append(cellModel)
                self?.answeredQuestionID = pendingQuestion.id
                self?.pollForAnswer(pendingQuestion)
            case .failure(let error):
                self?.handleError(error)
            }
        }
        latestQuestion = ""
    }

    func pollForAnswer(_ question: PendingQuestion) {
        cellModels.append(.gettingAnswer)
        chatService.pollForAnswer(question) { [weak self] result in
            self?.cellModels.removeLast()
            switch result {
            case .success(let answer):
                let cellModel = ChatCellViewModel(
                    answer: answer,
                    openURLAction: self?.openURLAction
                )
                self?.cellModels.append(cellModel)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }

    func loadHistory() {
        guard let conversationId = chatService.currentConversationId else {
            return
        }
        cellModels.removeAll()
        chatService.chatHistory(
            conversationId: conversationId
        ) { [weak self] result in
            switch result {
            case .success(let answers):
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
        (latestQuestion.count > maxCharacters)
    }


    private func handleHistoryResponse(_ history: History) {
        cellModels.removeAll()
        let answers = history.answeredQuestions
        answers.forEach { answeredQuestion in
            let question = ChatCellViewModel(answeredQuestion: answeredQuestion)
            cellModels.append(question)
            let answer = ChatCellViewModel(
                answer: answeredQuestion.answer,
                openURLAction: openURLAction
            )
            cellModels.append(answer)
        }
        if let pendingQuestion = history.pendingQuestion {
            askQuestion(pendingQuestion.message)
        }
    }

    @objc
    func newChat() {
        cellModels.removeAll()
        chatService.clearHistory()
    }
}
