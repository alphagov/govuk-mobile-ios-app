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
            description: "response_description",
            content: [
                .init(title: "content_1", description: "content_1_popular", isStepByStep: false, popular: true, url: .arrange),
                .init(title: "content_2", description: "content_2_sbs", isStepByStep: true, popular: false, url: .arrange),
                .init(title: "content_3", description: "content_3", isStepByStep: false, popular: false, url: .arrange),
                .init(title: "content_4", description: "content_4", isStepByStep: false, popular: false, url: .arrange),
                .init(title: "content_5", description: "content_5", isStepByStep: false, popular: false, url: .arrange),
            ],
            subtopics: [
                .init(ref: "subtopic_ref_1", title: "subtopic_title_1", description: "subtopic_desciption_1"),
                .init(ref: "subtopic_ref_2", title: "subtopic_title_2", description: "subtopic_desciption_2"),
                .init(ref: "subtopic_ref_3", title: "subtopic_title_3", description: "subtopic_desciption_3")
            ]
        )
    }

    static func arrangeLotsOfStepBySteps() -> TopicDetailResponse {
        .init(
            ref: "response_ref",
            title: "response_title",
            description: "response_description",
            content: [
                .init(title: "content_1", description: "content_1_popular", isStepByStep: false, popular: true, url: .arrange),
                .init(title: "content_2", description: "content_2_sbs", isStepByStep: true, popular: false, url: .arrange),
                .init(title: "content_3", description: "content_3", isStepByStep: false, popular: false, url: .arrange),
                .init(title: "content_4", description: "content_4", isStepByStep: false, popular: false, url: .arrange),
                .init(title: "content_5", description: "content_5", isStepByStep: false, popular: false, url: .arrange),
                .init(title: "content_6", description: "content_6", isStepByStep: true, popular: false, url: .arrange),
                .init(title: "content_7", description: "content_7", isStepByStep: true, popular: false, url: .arrange),
                .init(title: "content_8", description: "content_8", isStepByStep: true, popular: false, url: .arrange),
                .init(title: "content_9", description: "content_9", isStepByStep: true, popular: false, url: .arrange),
            ],
            subtopics: [
                .init(ref: "subtopic_ref_1", title: "subtopic_title_1", description: "subtopic_desciption_1"),
                .init(ref: "subtopic_ref_2", title: "subtopic_title_2", description: "subtopic_desciption_2"),
                .init(ref: "subtopic_ref_3", title: "subtopic_title_3", description: "subtopic_desciption_3"),
            ]
        )
    }

    static func arrangeOnlySubTopics() -> TopicDetailResponse {
        .init(
            ref: "response_ref",
            title: "response_title",
            description: "response_description",
            content: [],
            subtopics: [
                .init(ref: "subtopic_ref_1", title: "subtopic_title_1", description: "subtopic_desciption_1"),
                .init(ref: "subtopic_ref_2", title: "subtopic_title_2", description: "subtopic_desciption_2"),
                .init(ref: "subtopic_ref_3", title: "subtopic_title_3", description: "subtopic_desciption_3"),
                .init(ref: "subtopic_ref_4", title: "subtopic_title_4", description: "subtopic_desciption_4"),
                .init(ref: "subtopic_ref_5", title: "subtopic_title_5", description: "subtopic_desciption_5"),
            ]
        )
    }

}

extension TopicDetailResponse.Subtopic {

    static var arrange: TopicDetailResponse.Subtopic {
        arrange()
    }

    static func arrange(ref: String = "",
                        title: String = "",
                        description: String? = "") -> TopicDetailResponse.Subtopic {
        .init(
            ref: ref,
            title: title,
            description: description
        )
    }

}
