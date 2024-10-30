import Foundation

struct TopicResponseItem: Decodable {
    let ref: String
    let title: String
    let description: String?
}

struct TopicCreateParams {
    let ref: String
    let title: String
    let description: String?
    let isFavourite: Bool

    init(responseItem: TopicResponseItem,
         isFavourite: Bool) {
        self.ref = responseItem.ref
        self.title = responseItem.title
        self.description = responseItem.description
        self.isFavourite = isFavourite
    }
}
