import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    
    func fetchAllTopics() -> [Topic] {
        mockTopics
    }
    
    func fetchFavoriteTopics() -> [Topic] {
        mockTopics
    }
    
    var _updateFavoriteTopicsCalled = false
    func updateFavoriteTopics() {
        _updateFavoriteTopicsCalled = true
    }
    
    var _receivedFetchTopicsResult: Result<[TopicResponseItem], TopicsListError>?
    var _dataReceived = false
    func downloadTopicsList(completion: @escaping FetchTopicsListResult) {
        if let result = _receivedFetchTopicsResult {
            _dataReceived = (try? result.get()) != nil
            completion(result)
        } else {
            completion(.failure(.apiUnavailable))
        }
    }
}

extension MockTopicsService {
    static var testTopicsResult: Result<[TopicResponseItem], TopicsListError> {
        let topics = [TopicResponseItem(ref: "driving-transport", title: "Driving & Transport"),
                      TopicResponseItem(ref: "care", title: "Care"),
                      TopicResponseItem(ref: "business", title: "Business")
                      ]
        return .success(topics)
    }
    
    static var testTopicsFailure: Result<[TopicResponseItem], TopicsListError> {
        return .failure(.decodingError)
    }
    
    var mockTopics: [Topic] {
        let result = Self.testTopicsResult
        var topics = [Topic]()
        guard let topicResponses = try? result.get() else {
            return topics
        }
        for response in topicResponses {
            let topic = Topic(context: coreData.viewContext)
            topic.title = response.title
            topic.ref = response.ref
            topic.isFavorite = true
            topics.append(topic)
        }
        return topics
    }
}
