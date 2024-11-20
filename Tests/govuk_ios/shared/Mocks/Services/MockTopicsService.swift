import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {

    var _setHasCustomisedTopicsCalled: Bool = false
    func setHasCustomisedTopics() {
        _setHasCustomisedTopicsCalled = true
    }
    
    var _stubbedHasCustomisedTopics: Bool = false
    var hasCustomisedTopics: Bool {
        _stubbedHasCustomisedTopics
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

    var _stubbedFetchFavouriteTopics: [Topic]?
    func fetchFavourites() -> [Topic] {
        _stubbedFetchFavouriteTopics ?? []
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
