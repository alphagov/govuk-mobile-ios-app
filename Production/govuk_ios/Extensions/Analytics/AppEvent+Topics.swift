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

    static func topicLinkNavigation(content: TopicDetailResponse.Content) -> AppEvent {
        navigation(
            text: content.title,
            type: "Button",
            external: true,
            additionalParams: [
                "url": content.url.absoluteString,
                "section": sectionNameForContent(content)
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

    private static func sectionNameForContent(_ content: TopicDetailResponse.Content) -> String {
        if content.isStepByStep {
            return "Step by steps"
        }
        if content.popular {
            return "Popular"
        }
        return "Services and information"
    }
}
