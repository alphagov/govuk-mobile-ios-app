import Foundation
import SwiftUI
import UIComponents

enum ChatCellType {
    case question
    case pendingAnswer
    case answer
    case intro
}

struct ChatCellViewModel {
    let title: String?
    let message: String
    let id: String
    let type: ChatCellType
    let sources: [Source]
    let openURLAction: ((URL) -> Void)?

    init(title: String? = nil,
         message: String,
         id: String,
         type: ChatCellType,
         sources: [Source] = [],
         openURLAction: ((URL) -> Void)? = nil) {
        self.title = title
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
        self.init(title: String.chat.localized("answerTitle"),
                  message: answer.message ?? "",
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

    init(intro: Intro) {
        self.init(title: intro.title,
                  message: intro.message,
                  id: intro.id,
                  type: .intro)
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
        case .answer, .intro:
            Color(UIColor.govUK.fills.surfaceChatBlue)
        }
    }

    var borderColor: Color {
        switch type {
        case .question:
            Color(UIColor.govUK.strokes.chatQuestion)
        case .pendingAnswer:
            Color.clear
        case .answer, .intro:
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
