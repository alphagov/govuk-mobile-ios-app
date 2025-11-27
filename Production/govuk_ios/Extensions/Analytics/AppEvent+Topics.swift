import Foundation
import GOVKit

extension AppEvent {
    static func topicSelection(title: String,
                               section: String,
                               isFavourite: Bool) -> AppEvent {
        buttonFunction(
            text: title,
            section: section,
            action: isFavourite ? "add" : "remove"
        )
    }

    static func topicLinkNavigation(content: TopicDetailResponse.Content,
                                    sectionTitle: String) -> AppEvent {
        topicLinkNavigation(
            title: content.title,
            sectionTitle: sectionTitle,
            url: content.url.absoluteString,
            external: true
        )
    }

    static func topicLinkNavigation(title: String,
                                    sectionTitle: String,
                                    url: String?,
                                    external: Bool) -> AppEvent {
        navigation(
            text: title,
            type: "Button",
            external: external,
            additionalParams: [
                "url": url,
                "section": sectionTitle
            ].mapValues { $0 }
        )
    }

    static func subtopicNavigation(subtopic: TopicDetailResponse.Subtopic) -> AppEvent {
        navigation(
            text: subtopic.title,
            type: "Button",
            external: false,
            additionalParams: [
                "section": "Sub topics"
            ]
        )
    }
}
