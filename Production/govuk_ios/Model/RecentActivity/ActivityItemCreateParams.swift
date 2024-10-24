import Foundation

struct ActivityItemCreateParams {
    var id: String
    var title: String
    var date: Date
    var url: String
}

extension ActivityItemCreateParams {
    init(searchItem: SearchItem) {
        self.id = searchItem.link.absoluteString
        self.title = searchItem.title
        self.date = Date()
        self.url = searchItem.link.absoluteString
    }

    init(topicContent: TopicDetailResponse.Content) {
        self.id = topicContent.url.absoluteString
        self.title = topicContent.title
        self.date = Date()
        self.url = topicContent.url.absoluteString
    }
}
