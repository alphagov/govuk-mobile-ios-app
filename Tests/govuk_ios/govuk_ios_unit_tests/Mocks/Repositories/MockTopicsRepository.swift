import Foundation

@testable import govuk_ios

class MockTopicsRepository: TopicsRepositoryInterface {
    
    func saveTopicsList(_ topicResponses: [TopicResponseItem]) {
        
    }
    
    func fetchFavoriteTopics() -> [Topic] {
        []
    }
    
    func fetchAllTopics() -> [Topic] {
        []
    }
    
    
    func saveChanges() {
        
    }
}
