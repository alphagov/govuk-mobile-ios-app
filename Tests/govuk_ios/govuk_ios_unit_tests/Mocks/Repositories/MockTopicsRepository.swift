import Foundation

@testable import govuk_ios

class MockTopicsRepository: TopicsRepositoryInterface {
    
    var _didCallSaveTopicsList = false
    func saveTopicsList(_ topicResponses: [TopicResponseItem]) {
        self._didCallSaveTopicsList = true
    }
    
    var _didCallFetchFavorites = false
    func fetchFavoriteTopics() -> [Topic] {
        self._didCallFetchFavorites = true
        return []
    }
    
    var _didCallFetchAll = false
    func fetchAllTopics() -> [Topic] {
        self._didCallFetchAll = true
        return []
    }
    
    var _didCallSaveChanges = false
    func saveChanges() {
        self._didCallSaveChanges = true
    }
}
