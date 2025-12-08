import Foundation
import SwiftUI
import UIComponents
import GOVKit
import MarkdownUI

enum ChatLinkType: String {
    case sourceLink = "Source Link"
    case responseLink = "Response Link"
}

enum ChatCellType {
    case question
    case pendingAnswer
    case answer
    case intro
    case loading
}

class ChatCellViewModel: ObservableObject {
    let title: String?
    let message: String
    let id: String
    let type: ChatCellType
    let sources: [Source]
    let openURLAction: ((URL) -> Void)?
    let analyticsService: AnalyticsServiceInterface?
    @Published var isVisible: Bool = false

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

    convenience init(question: PendingQuestion,
                     analyticsService: AnalyticsServiceInterface) {
        self.init(message: question.message,
                  id: question.id,
                  type: .question,
                  analyticsService: analyticsService)
    }

    convenience init(answer: Answer,
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

    convenience init(answeredQuestion: AnsweredQuestion,
                     analyticsService: AnalyticsServiceInterface) {
        self.init(message: answeredQuestion.message,
                  id: answeredQuestion.id,
                  type: .question,
                  sources: [],
                  analyticsService: analyticsService)
    }

    convenience init(intro: Intro,
                     analyticsService: AnalyticsServiceInterface) {
        self.init(title: intro.title,
                  message: intro.message,
                  id: intro.id,
                  type: .intro,
                  analyticsService: analyticsService)
    }

    var isAnswer: Bool {
        (type == .question || type ==  .loading) ? false : true
    }

    var accessibilityPrompt: String {
        type == .question ? String.chat.localized("accessibilityPrompt") : ""
    }

    func copyToClipboard() {
        var textToCopy = MarkdownContent(message).renderPlainText()
        if !sources.isEmpty {
            textToCopy.append("\n\n" + String.chat.localized("mistakesTitle"))
            sources.forEach { source in
                textToCopy.append("\n\n" + source.url)
            }
        }
        UIPasteboard.general.string = textToCopy
        trackCopyToClipboard()
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

    func trackCopyToClipboard() {
        let event = AppEvent.buttonFunction(
            text: "Copy to clipboard",
            section: "Chat \(isAnswer ? "Answer" : "Question")",
            action: "Copy"
        )
        analyticsService?.track(event: event)
    }
}

// MARK: Layout and animation
extension ChatCellViewModel {
    var backgroundColor: Color {
        switch type {
        case .question, .loading:
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

    var anchor: UnitPoint {
        switch type {
        case .intro:
                .center
        case .question, .loading:
                .bottomTrailing
        case .pendingAnswer, .answer:
                .bottomLeading
        }
    }

    var scale: CGFloat {
        let localScale = if type == .pendingAnswer {
            1.0
        } else {
            0.90
        }
        return isVisible ? 1 : localScale
    }

    var duration: CGFloat {
        if type == .intro {
            0.5
        } else {
            0.25
        }
    }

    var delay: CGFloat {
        if type == .loading {
            0.4
        } else {
            0.0
        }
    }

    var topPadding: CGFloat {
        if type == .intro {
            0.0
        } else {
            8.0
        }
    }
}

// MARK: - Convenience
extension ChatCellViewModel {
    static var loadingQuestion: ChatCellViewModel = .init(
        message: String.chat.localized("loadingQuestionMessage"),
        id: UUID().uuidString,
        type: .loading
    )

    static var gettingAnswer: ChatCellViewModel = .init(
        message: String.chat.localized("gettingAnswerMessage"),
        id: UUID().uuidString,
        type: .pendingAnswer
    )
}
