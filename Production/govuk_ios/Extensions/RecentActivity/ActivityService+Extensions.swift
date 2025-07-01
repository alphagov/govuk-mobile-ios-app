import Foundation

extension ActivityServiceInterface {
    func save(searchItem: SearchItem) {
        let params = ActivityItemCreateParams(
            searchItem: searchItem
        )
        self.save(activity: params)
    }

    func save(topicContent: TopicDetailResponse.Content) {
        let params = ActivityItemCreateParams(
            topicContent: topicContent
        )
        self.save(activity: params)
    }
}
