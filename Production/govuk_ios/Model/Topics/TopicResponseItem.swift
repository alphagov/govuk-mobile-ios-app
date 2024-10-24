import Foundation

struct TopicResponseItem: Decodable {
    let ref: String
    let title: String
    let description: String?
}
