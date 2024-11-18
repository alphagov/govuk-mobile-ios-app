import Foundation

@testable import govuk_ios

class MockTopicsRepository: TopicsRepositoryInterface {
    
    var _didCallSaveTopicsList = false
    func save(topics: [TopicResponseItem]) {
        _didCallSaveTopicsList = true
    }
    
    var _didCallFetchFavourites = false
    func fetchFavourites() -> [Topic] {
        _didCallFetchFavourites = true
        return []
    }
    
    var _didCallFetchAll = false
    func fetchAll() -> [Topic] {
        _didCallFetchAll = true
        return []
    }
    
    var _didCallSaveChanges = false
    func save() {
        _didCallSaveChanges = true
    }
}
