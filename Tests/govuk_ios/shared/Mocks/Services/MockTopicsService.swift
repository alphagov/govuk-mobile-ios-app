import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {

    var _setHasPersonalisedTopicsCalled: Bool = false
    func setHasPersonalisedTopics() {
        _setHasPersonalisedTopicsCalled = true
    }
    
    var _stubbedHasPersonalisedTopics: Bool = false
    var hasPersonalisedTopics: Bool {
        _stubbedHasPersonalisedTopics
    }

    var _stubbedHasOnboardedTopics: Bool = false
    var hasOnboardedTopics: Bool {
        _stubbedHasOnboardedTopics
    }

    var _setHasOnboardedTopicsCalled: Bool = false
    func setHasOnboardedTopics() {
        _setHasOnboardedTopicsCalled = true
    }

    let coreData = CoreDataRepository.arrangeAndLoad
    
    var _stubbedFetchAllTopics: [Topic]?
    func fetchAll() -> [Topic] {
        _stubbedFetchAllTopics ?? []
    }

    var _stubbedFetchFavoriteTopics: [Topic]?
    func fetchFavorites() -> [Topic] {
        _stubbedFetchFavoriteTopics ?? []
    }

    var _saveCalled = false
    func save() {
        _saveCalled = true
    }
    
    var _stubbedFetchRemoteListResult: Result<[TopicResponseItem], TopicsServiceError>?
    func fetchRemoteList(completion: @escaping FetchTopicsListResult) {
        if let result = _stubbedFetchRemoteListResult {
            completion(result)
        } else {
            completion(.failure(.apiUnavailable))
        }
    }
    
    var _stubbedFetchTopicDetailsResult: Result<TopicDetailResponse, TopicsServiceError>?
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsResult) {
        if let result = _stubbedFetchTopicDetailsResult {
            completion(result)
        } else {
            completion(.failure(.apiUnavailable))
        }
    }
}
