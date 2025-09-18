import Foundation
import SwiftUI
import UIComponents
import GOVKit

enum ChatLinkType: String {
    case sourceLink = "Source Link"
    case responseLink = "Response Link"
}

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
    let analyticsService: AnalyticsServiceInterface?

    init(title: String? = nil,
         message: String,
         id: String,
         type: ChatCellType,
         sources: [Source] = [],
         openURLAction: ((URL) -> Void)? = nil,
         analyticsService: AnalyticsServiceInterface? = nil) {
        self.title = title
        self.message = message
        self.id = id
        self.type = type
        self.sources = sources
        self.openURLAction = openURLAction
        self.analyticsService = analyticsService
    }

    init(question: PendingQuestion) {
        self.init(message: question.message,
                  id: question.id,
                  type: .question)
    }

    init(answer: Answer,
         openURLAction: @escaping (URL) -> Void,
         analyticsService: AnalyticsServiceInterface) {
        self.init(
            title: String.chat.localized("answerTitle"),
            message: answer.message ?? "",
            id: answer.id ?? UUID().uuidString,
            type: .answer,
            sources: answer.sources ?? [],
            openURLAction: openURLAction,
            analyticsService: analyticsService
        )
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
            Color(UIColor.clear)
        case .answer, .intro:
            Color(UIColor.govUK.fills.surfaceChatBlue)
        }
    }

    var questionWidth: CGFloat {
        UIScreen.main.bounds.width * 0.2
    }

    func openURL(url: URL, type: ChatLinkType) {
        openURLAction?(url)
        let event = AppEvent.chatLinkNavigation(
            text: "\(type.rawValue) Opened",
            url: url.absoluteString
        )
        analyticsService?.track(event: event)
    }

    func trackSourceListToggle(isExpanded: Bool) {
        guard isExpanded else { return }

        let event = AppEvent.buttonFunction(
            text: "Expanded",
            section: "Source Links",
            action: "Source Links Expanded"
        )
        analyticsService?.track(event: event)
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
