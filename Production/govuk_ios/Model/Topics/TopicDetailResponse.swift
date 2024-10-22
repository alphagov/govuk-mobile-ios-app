import Foundation

struct TopicDetailResponse: Decodable {
    let content: [Content]
    let ref: String
    let subtopics: [Subtopic]
    let title: String

    struct Subtopic: Decodable {
        let ref: String
        let title: String
    }

    struct Content: Decodable {
        let description: String
        let isStepByStep: Bool
        let popular: Bool
        let title: String
        let url: URL
    }
}

extension TopicDetailResponse: DisplayableTopic {}
extension TopicDetailResponse.Subtopic: DisplayableTopic {}

extension TopicDetailResponse {
    var popularContent: [TopicDetailResponse.Content]? {
        let localContent = content.filter {
            $0.popular && !$0.isStepByStep
        }

        guard localContent.count > 0
        else { return nil }

        return localContent
    }

    var stepByStepContent: [TopicDetailResponse.Content]? {
        let localContent = content.filter { $0.isStepByStep }
        guard localContent.count > 0
        else { return nil }
        return localContent
    }

    var otherContent: [TopicDetailResponse.Content]? {
        let otherContent = content.filter {
            !$0.isStepByStep && !$0.popular
        }
        guard otherContent.count > 0
        else { return nil }
        return otherContent
    }
}
