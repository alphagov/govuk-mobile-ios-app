import Foundation

@testable import govuk_ios

class MockTopicsRepository: TopicsRepositoryInterface {
    
    var _didCallSaveTopicsList = false
    func saveTopicsList(_ topicResponses: [TopicResponseItem]) {
        _didCallSaveTopicsList = true
    }
    
    var _didCallFetchFavorites = false
    func fetchFavoriteTopics() -> [Topic] {
        _didCallFetchFavorites = true
        return []
    }
    
    var _didCallFetchAll = false
    func fetchAllTopics() -> [Topic] {
        _didCallFetchAll = true
        return []
    }
    
    var _didCallSaveChanges = false
    func saveChanges() {
        _didCallSaveChanges = true
    }
}
