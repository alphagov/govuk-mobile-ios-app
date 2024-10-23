import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    
    var _stubbedFetchAllTopics: [Topic]?
    func fetchAllTopics() -> [Topic] {
        _stubbedFetchAllTopics ?? mockTopics
    }

    var _allTopicsFavourited = true
    func fetchFavoriteTopics() -> [Topic] {
        var topics = mockTopics
        guard (_allTopicsFavourited == false) else { return topics }
        topics.removeLast()
        return topics
    }

    var _updateFavoriteTopicsCalled = false
    func updateFavoriteTopics() {
        _updateFavoriteTopicsCalled = true
    }
    
    var _receivedFetchTopicsResult: Result<[TopicResponseItem], TopicsServiceError>?
    var _dataReceived = false
    func downloadTopicsList(completion: @escaping FetchTopicsListResult) {
        if let result = _receivedFetchTopicsResult {
            _dataReceived = (try? result.get()) != nil
            completion(result)
        } else {
            completion(.failure(.apiUnavailable))
        }
    }
    
    var _stubbedFetchTopicDetailsResult: Result<TopicDetailResponse, TopicsServiceError>?
    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult) {
        if let result = _stubbedFetchTopicDetailsResult {
            completion(result)
        } else {
            completion(.failure(.apiUnavailable))
        }
    }
}

extension MockTopicsService {
    static var testTopicsResult: Result<[TopicResponseItem], TopicsServiceError> {
        let topics = [TopicResponseItem(ref: "driving-transport", title: "Driving & Transport"),
                      TopicResponseItem(ref: "care", title: "Care"),
                      TopicResponseItem(ref: "business", title: "Business")
                      ]
        return .success(topics)
    }
    
    static var testTopicsFailure: Result<[TopicResponseItem], TopicsServiceError> {
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
    
    static func createTopicDetails(fileName: String) -> Result<TopicDetailResponse, TopicsServiceError> {
        let data = getJsonData(filename: fileName, bundle: .main)
        guard let details = try? JSONDecoder().decode(TopicDetailResponse.self, from: data)
        else {
            return .failure(TopicsServiceError.decodingError)
        }
        return .success(details)
    }
    
    private static  func getJsonData(filename: String, bundle: Bundle) -> Data {
        let resourceURL = bundle.url(
            forResource: filename,
            withExtension: "json"
        )
        guard let resourceURL = resourceURL else {
            return Data()
        }
        do {
            return try Data(contentsOf: resourceURL)
        } catch {
            return Data()
        }
    }
}
