import Foundation

extension AppEvent {
    static func toggleTopic(title: String,
                            isFavorite: Bool) -> AppEvent {
        toggle(
            text: title,
            section: "Topics",
            isOn: isFavorite
        )
    }

    static func topicLinkNavigation(content: TopicDetailResponse.Content,
                                    sectionTitle: String) -> AppEvent {
        navigation(
            text: content.title,
            type: "Button",
            external: true,
            additionalParams: [
                "url": content.url.absoluteString,
                "section": sectionTitle
            ]
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
