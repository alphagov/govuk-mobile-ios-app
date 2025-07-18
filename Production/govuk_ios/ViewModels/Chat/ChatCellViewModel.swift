import Foundation
import SwiftUI
import UIComponents

enum ChatCellType {
    case question
    case pendingAnswer
    case answer
}

struct ChatCellViewModel {
    let message: String
    let id: String
    let type: ChatCellType
    let sources: [Source]
    let openURLAction: ((URL) -> Void)?

    init(message: String,
         id: String,
         type: ChatCellType,
         sources: [Source] = [],
         openURLAction: ((URL) -> Void)? = nil) {
        self.message = message
        self.id = id
        self.type = type
        self.sources = sources
        self.openURLAction = openURLAction
    }

    init(question: PendingQuestion) {
        self.init(message: question.message,
                  id: question.id,
                  type: .question)
    }

    init(answer: Answer,
         openURLAction: ((URL) -> Void)? ) {
        self.init(message: answer.message ?? "",
                  id: answer.id ?? UUID().uuidString,
                  type: .answer,
                  sources: answer.sources ?? [],
                  openURLAction: openURLAction)
    }

    init(answeredQuestion: AnsweredQuestion) {
        self.init(message: answeredQuestion.message,
                  id: answeredQuestion.id,
                  type: .question,
                  sources: [])
    }

    var isAnswer: Bool {
        type == .question ? false : true
    }

    var backgroundColor: Color {
        switch type {
        case .question:
            Color(UIColor.govUK.fills.surfaceChatQuestion)
        case .pendingAnswer:
            Color(UIColor.govUK.fills.surfaceBackground)
        case .answer:
            Color(UIColor.govUK.fills.surfaceChatBlue)
        case .error:
            Color(UIColor.govUK.fills.surfaceChatBlue)
        }
    }

    var borderColor: Color {
        switch type {
        case .question:
            Color(UIColor.govUK.strokes.chatQuestion)
        case .pendingAnswer:
            Color.clear
        case .answer:
            Color(UIColor.govUK.strokes.chatDivider)
        case .error:
            Color(UIColor.govUK.strokes.chatDivider)
        }
    }

    var questionWidth: CGFloat {
        UIScreen.main.bounds.width * 0.2
    }
}

extension ChatCellViewModel {
    static var loadingQuestion: ChatCellViewModel = .init(
        message: String.chat.localized("loadingQuestionMessage"),
        id: UUID().uuidString,
        type: .question
    )

    static var gettingAnswer: ChatCellViewModel = .init(
        message: String.chat.localized("gettingAnswerMessage"),
        id: UUID().uuidString,
        type: .pendingAnswer
    )
}
