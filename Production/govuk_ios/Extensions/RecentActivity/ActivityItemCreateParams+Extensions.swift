import Foundation

extension ActivityItemCreateParams {
    init(searchItem: SearchItem) {
        self.init(
            id: searchItem.link.absoluteString,
            title: searchItem.title,
            date: Date(),
            url: searchItem.link.absoluteString
        )
    }

    init(topicContent: TopicDetailResponse.Content) {
        self.init(
            id: topicContent.url.absoluteString,
            title: topicContent.title,
            date: Date(),
            url: topicContent.url.absoluteString
        )
    }
}
