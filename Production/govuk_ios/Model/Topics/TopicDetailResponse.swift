import Foundation

struct TopicDetailResponse: Decodable {
    let ref: String
    let title: String
    let topicDescription: String?
    let content: [Content]
    let subtopics: [Subtopic]

    enum CodingKeys: String, CodingKey {
        case ref
        case title
        case topicDescription = "description"
        case content
        case subtopics
    }

    struct Subtopic: Decodable {
        let ref: String
        let title: String
        let topicDescription: String?

        enum CodingKeys: String, CodingKey {
            case ref
            case title
            case topicDescription = "description"
        }
    }

    struct Content: Decodable {
        let title: String
        let description: String?
        let isStepByStep: Bool
        let popular: Bool
        let url: URL
    }
}

extension TopicDetailResponse {
    var popularContent: [TopicDetailResponse.Content]? {
        let localContent = content.filter { $0.popular && !$0.isStepByStep }
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
        let localContent = content.filter {
            !$0.isStepByStep && !$0.popular
        }
        guard localContent.count > 0
        else { return nil }
        return localContent
    }
}

extension TopicDetailResponse: DisplayableTopic {}
extension TopicDetailResponse.Subtopic: DisplayableTopic {}
