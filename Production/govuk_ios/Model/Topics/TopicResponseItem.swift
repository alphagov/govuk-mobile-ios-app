import Foundation

struct TopicResponseItem: Decodable {
    let ref: String
    let title: String
    let description: String?
}

protocol TopicCreateParams {
    var ref: String { get }
    var title: String { get }
    var description: String? { get }
}

protocol TopicUpdateParams: TopicCreateParams {
    var isFavourite: Bool { get }
}
