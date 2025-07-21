import SwiftUI
import GOVKit
import UIComponents

class ChatViewModel: ObservableObject {
    private let chatService: ChatServiceInterface
    private let analyticsService: AnalyticsServiceInterface

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
                let cellModel = ChatCellViewModel(error: error)
                self?.cellModels.append(cellModel)
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
                let cellModel = ChatCellViewModel(answer: answer)
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
                let cellModel = ChatCellViewModel(error: error)
                self?.cellModels.append(cellModel)
            }
            self?.scrollToBottom = true
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
