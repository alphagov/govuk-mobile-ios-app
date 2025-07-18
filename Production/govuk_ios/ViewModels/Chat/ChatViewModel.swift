import SwiftUI
import GOVKit
import UIComponents

class ChatViewModel: ObservableObject {
    private let chatService: ChatServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let handleError: (Error) -> Void

    @Published private(set) var questionInProgress: Bool = false
    @Published var cellModels: [ChatCellViewModel] = []
    @Published var latestQuestion: String = ""
    @Published var scrollToBottom: Bool = false
    @Published var answeredQuestionID: String = ""

    init(chatService: ChatServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         handleError: @escaping (Error) -> Void) {
        self.chatService = chatService
        self.analyticsService = analyticsService
        self.handleError = handleError
    }

    func askQuestion(_ question: String? = nil) {
        // show question in chat
        let questionModel = ChatCellViewModel(message: question ?? latestQuestion,
                                              id: UUID().uuidString,
                                              type: .question)
        cellModels.append(questionModel)
        questionInProgress = true
        cellModels.append(.placeHolder)
        scrollToBottom = true
        chatService.askQuestion(latestQuestion) { [weak self] result in
            self?.questionInProgress = false
            self?.cellModels.removeLast()
            switch result {
            case .success(let answer):
                guard answer.message != nil else { return }
                let cellModel = ChatCellViewModel(answer: answer)
                self?.cellModels.append(cellModel)
            case .failure(let error):
                if error == .pageNotFound &&
                    self?.chatService.currentConversationId != nil {
                    self?.chatService.clearHistory()
                    self?.cellModels.removeLast()
                    self?.askQuestion(question)
                } else {
                    self?.handleError(error)
                }
            }
            self?.answeredQuestionID = questionModel.id
        }
        latestQuestion = ""
    }

    var sendButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: String.chat.localized("sendButtonTitle"),
              action: { [weak self] in
            self?.askQuestion()
        })
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

    private func handleHistoryResponse(_ history: History) {
        cellModels.removeAll()
        let answers = history.answeredQuestions
        answers.forEach { answeredQuestion in
            let question = ChatCellViewModel(answeredQuestion: answeredQuestion)
            cellModels.append(question)
            let answer = ChatCellViewModel(answer: answeredQuestion.answer)
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
