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

    func askQuestion() {
        cellModels.append(.loadingQuestion)
        scrollToBottom = true
        chatService.askQuestion(latestQuestion) { [weak self] result in
            self?.cellModels.removeLast()
            switch result {
            case .success(let question):
                let cellModel = ChatCellViewModel(question: question)
                self?.cellModels.append(cellModel)
                self?.answeredQuestionID = question.id
                self?.pollForAnswer(question)
            case .failure(let error):
                self?.handleError(error)
            }
        }
        latestQuestion = ""
    }

    private func pollForAnswer(_ question: PendingQuestion) {
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
                let cellModel = ChatCellViewModel(error: error)
                self?.cellModels.append(cellModel)
            }
        }
    }

    func loadHistory() {
        cellModels.removeAll()
        chatService.chatHistory(
            conversationId: chatService.currentConversationId
        ) { [weak self] result in
            switch result {
            case .success(let answers):
                self?.handleHistoryResponse(answers)
            case .failure(let error):
                self?.handleError(error)
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

    private func handleHistoryResponse(_ answers: [AnsweredQuestion]) {
        answers.forEach { answeredQuestion in
            let question = ChatCellViewModel(answeredQuestion: answeredQuestion)
            cellModels.append(question)
            let answer = ChatCellViewModel(
                answer: answeredQuestion.answer,
                openURLAction: openURLAction
            )
            cellModels.append(answer)
        }
    }

    @objc
    func newChat() {
        cellModels.removeAll()
        chatService.clearHistory()
    }
}
