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
