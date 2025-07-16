import Foundation
import SwiftUI
import UIComponents

enum ChatCellType {
    case question
    case pendingAnswer
    case answer
    case error
}

struct ChatCellViewModel {
    var message: String
    let id: String
    let type: ChatCellType
    let sources: [Source]
    var attrSting: AttributedString?

    init(message: String,
         id: String,
         type: ChatCellType,
         sources: [Source] = []) {
        self.message = message
        self.id = id
        self.type = type
        self.sources = sources
    }

    init(answer: Answer) {
        self.init(message: answer.message ?? "",
                  id: answer.id ?? UUID().uuidString,
                  type: .answer,
                  sources: answer.sources ?? [])
    }

    init(answeredQuestion: AnsweredQuestion) {
        self.init(message: answeredQuestion.message,
                  id: answeredQuestion.id,
                  type: .question,
                  sources: answeredQuestion.answer.sources ?? [])
    }

    init(error: Error) {
        self.init(message: error.localizedDescription,
                  id: UUID().uuidString,
                  type: .error,
                  sources: [])
    }

    var isAnswer: Bool {
        type == .question ? false : true
    }

    var backgroundColor: Color {
        isAnswer ?
        Color(UIColor.govUK.fills.surfaceChatBlue) :
        Color(UIColor.govUK.fills.surfaceChatQuestion)
    }

    var borderColor: Color {
        isAnswer ?
        Color(UIColor.govUK.strokes.chatAnswer) :
        Color(UIColor.govUK.strokes.chatQuestion)
    }

    var questionWidth: CGFloat {
        UIScreen.main.bounds.width * 0.2
    }
}

extension ChatCellViewModel {
    static var placeHolder: ChatCellViewModel = .init(
        message: String.chat.localized("gettingAnswerTitle"),
        id: UUID().uuidString,
        type: .pendingAnswer
    )
}
