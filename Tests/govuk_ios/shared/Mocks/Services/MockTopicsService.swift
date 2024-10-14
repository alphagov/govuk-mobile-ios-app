import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {
    
    func fetchAllTopics() -> [Topic] {
        []
    }
    
    func fetchFavoriteTopics() -> [Topic] {
        []
    }
    
    var _didUpdateFavoritesCalled = false
    func updateFavoriteTopics() {
        _didUpdateFavoritesCalled = true
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
}
