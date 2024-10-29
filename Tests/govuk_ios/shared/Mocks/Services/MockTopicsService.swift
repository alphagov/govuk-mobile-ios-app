import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {

    var _setHasEditedTopics: Bool = false
    func setHasEditedTopics() {
        return _setHasEditedTopics = true
    }
    
    var _stubbedHasTopicsBeenEdited: Bool = false
    var hasTopicsBeenEdited: Bool {
        return _stubbedHasTopicsBeenEdited
    }

    var _stubbedHasOnboardedTopics: Bool = false
    var hasOnboardedTopics: Bool {
        return _stubbedHasOnboardedTopics
    }

    var _setHasOnboardedTopics: Bool = false
    func setHasOnboardedTopics() {
        _setHasOnboardedTopics = true
    }

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
