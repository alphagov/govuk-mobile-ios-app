import Foundation

@testable import govuk_ios

extension TopicDetailResponse {

    static func arrange(fileName: String) -> TopicDetailResponse {
        try! JSONDecoder().decode(
            from: .load(filename: fileName)
        )
    }

    static func arrange() -> TopicDetailResponse {
        .init(
            ref: "response_ref",
            title: "response_title",
            topicDescription: "response_description",
            content: [
                .arrange(title: "content_1", description: "content_1_popular", isStepByStep: false, popular: true),
                .arrange(title: "content_2", description: "content_2_sbs", isStepByStep: true, popular: false),
                .arrange(title: "content_3", description: "content_3", isStepByStep: false, popular: false),
                .arrange(title: "content_4", description: "content_4", isStepByStep: false, popular: false),
                .arrange(title: "content_5", description: "content_5", isStepByStep: false, popular: false),
            ],
            subtopics: [
                .arrange(ref: "subtopic_ref_1", title: "subtopic_title_1", description: "subtopic_desciption_1"),
                .arrange(ref: "subtopic_ref_2", title: "subtopic_title_2", description: "subtopic_desciption_2"),
                .arrange(ref: "subtopic_ref_3", title: "subtopic_title_3", description: "subtopic_desciption_3")
            ]
        )
    }

    static func arrangeLotsOfStepBySteps() -> TopicDetailResponse {
        .init(
            ref: "response_ref",
            title: "response_title",
            topicDescription: "response_description",
            content: [
                .arrange(title: "content_1", description: "content_1_popular", popular: true),
                .arrange(title: "content_2", description: "content_2_sbs", isStepByStep: true),
                .arrange(title: "content_3", description: "content_3"),
                .arrange(title: "content_4", description: "content_4"),
                .arrange(title: "content_5", description: "content_5"),
                .arrange(title: "content_6", description: "content_6", isStepByStep: true),
                .arrange(title: "content_7", description: "content_7", isStepByStep: true),
                .arrange(title: "content_8", description: "content_8", isStepByStep: true),
                .arrange(title: "content_9", description: "content_9", isStepByStep: true),
            ],
            subtopics: [
                .arrange(title: "subtopic_title_1", description: "subtopic_desciption_1"),
                .arrange(title: "subtopic_title_2", description: "subtopic_desciption_2"),
                .arrange(title: "subtopic_title_3", description: "subtopic_desciption_3"),
            ]
        )
    }

    static func arrangeOnlySubTopics() -> TopicDetailResponse {
        .init(
            ref: "response_ref",
            title: "response_title",
            topicDescription: "response_description",
            content: [],
            subtopics: [
                .arrange(title: "subtopic_title_1", description: "subtopic_desciption_1"),
                .arrange(title: "subtopic_title_2", description: "subtopic_desciption_2"),
                .arrange(title: "subtopic_title_3", description: "subtopic_desciption_3"),
                .arrange(title: "subtopic_title_4", description: "subtopic_desciption_4"),
                .arrange(title: "subtopic_title_5", description: "subtopic_desciption_5"),
            ]
        )
    }

}

extension TopicDetailResponse.Subtopic {

    static var arrange: TopicDetailResponse.Subtopic {
        arrange()
    }

    static func arrange(ref: String = UUID().uuidString,
                        title: String = UUID().uuidString,
                        description: String? = nil) -> TopicDetailResponse.Subtopic {
        .init(
            ref: ref,
            title: title,
            topicDescription: description
        )
    }

}

extension TopicDetailResponse.Content {

    static var arrange: TopicDetailResponse.Content {
        arrange()
    }

    static func arrange(title: String = UUID().uuidString,
                        description: String? = UUID().uuidString,
                        isStepByStep: Bool = false,
                        popular: Bool = false,
                        url: URL = .arrange) -> TopicDetailResponse.Content {
        .init(
            title: title,
            description: description,
            isStepByStep: isStepByStep,
            popular: popular,
            url: url
        )
    }

}
