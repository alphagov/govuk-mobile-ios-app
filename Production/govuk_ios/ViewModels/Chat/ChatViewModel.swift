import SwiftUI
import GOVKit
import UIComponents

class ChatViewModel: ObservableObject {
    private let chatService: ChatServiceInterface
    private let analyticsService: AnalyticsServiceInterface

    @Published private(set) var questionInProgress: Bool = false
    @Published var cellModels: [ChatCellViewModel] = []
    @Published var latestQuestion: String = ""
    @Published var scrollToBottom: Bool = false
    @Published var answeredQuestionID: String = ""

    init(chatService: ChatServiceInterface,
         analyticsService: AnalyticsServiceInterface) {
        self.chatService = chatService
        self.analyticsService = analyticsService
    }

    func askQuestion() {
        // show question in chat
        let questionModel = ChatCellViewModel(message: latestQuestion,
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
                let cellModel = ChatCellViewModel(error: error)
                self?.cellModels.append(cellModel)
            }
            self?.answeredQuestionID = questionModel.id
        }
        latestQuestion = ""
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
                let cellModel = ChatCellViewModel(error: error)
                self?.cellModels.append(cellModel)
            }
        }
    }

    private func handleHistoryResponse(_ answers: [AnsweredQuestion]) {
        answers.forEach { answeredQuestion in
            let question = ChatCellViewModel(answeredQuestion: answeredQuestion)
            cellModels.append(question)
            let answer = ChatCellViewModel(answer: answeredQuestion.answer)
            cellModels.append(answer)
        }
    }

    @objc
    func newChat() {
        cellModels.removeAll()
        chatService.clearHistory()
    }
}
