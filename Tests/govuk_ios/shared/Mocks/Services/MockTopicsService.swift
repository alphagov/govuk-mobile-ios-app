import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    
    var _stubbedFetchAllTopics: [Topic]?
    func fetchAllTopics() -> [Topic] {
        _stubbedFetchAllTopics ?? []
    }

    var _stubbedFetchFavoriteTopics: [Topic]?
    func fetchFavoriteTopics() -> [Topic] {
        _stubbedFetchFavoriteTopics ?? []
    }

    var _updateFavoriteTopicsCalled = false
    func updateFavoriteTopics() {
        _updateFavoriteTopicsCalled = true
    }
    
    var _stubbedDownloadTopicsListResult: Result<[TopicResponseItem], TopicsServiceError>?
    var _dataReceived = false
    func downloadTopicsList(completion: @escaping FetchTopicsListResult) {
        if let result = _stubbedDownloadTopicsListResult {
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
