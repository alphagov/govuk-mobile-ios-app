import Foundation

@testable import govuk_ios

extension TopicDetailResponse {

    static func arrange() -> TopicDetailResponse {
        .init(
            content: [
                .init(description: "content_1_popular", isStepByStep: false, popular: true, title: "content_1", url: .arrange),
                .init(description: "content_2_sbs", isStepByStep: true, popular: false, title: "content_2", url: .arrange),
                .init(description: "content_3", isStepByStep: false, popular: false, title: "content_3", url: .arrange),
                .init(description: "content_4", isStepByStep: false, popular: false, title: "content_4", url: .arrange),
                .init(description: "content_5", isStepByStep: false, popular: false, title: "content_5", url: .arrange),
            ],
            ref: "test_ref",
            subtopics: [

            ],
            title: "test_title"
        )
    }

    static func arrangeLotsOfStepBySteps() -> TopicDetailResponse {
        .init(
            content: [
                .init(description: "content_1_popular", isStepByStep: false, popular: true, title: "content_1", url: .arrange),
                .init(description: "content_2_sbs", isStepByStep: true, popular: false, title: "content_2", url: .arrange),
                .init(description: "content_3", isStepByStep: false, popular: false, title: "content_3", url: .arrange),
                .init(description: "content_4", isStepByStep: false, popular: false, title: "content_4", url: .arrange),
                .init(description: "content_5", isStepByStep: false, popular: false, title: "content_5", url: .arrange),
                .init(description: "content_6", isStepByStep: true, popular: false, title: "content_6", url: .arrange),
                .init(description: "content_7", isStepByStep: true, popular: false, title: "content_7", url: .arrange),
                .init(description: "content_8", isStepByStep: true, popular: false, title: "content_8", url: .arrange),
                .init(description: "content_9", isStepByStep: true, popular: false, title: "content_9", url: .arrange),
            ],
            ref: "test_ref",
            subtopics: [

            ],
            title: "test_title"
        )
    }

}
