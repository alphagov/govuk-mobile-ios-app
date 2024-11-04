import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {

    var _setHasEditedTopicsCalled: Bool = false
    func setHasEditedTopics() {
        return _setHasEditedTopicsCalled = true
    }
    
    var _stubbedHasTopicsBeenEdited: Bool = false
    var hasTopicsBeenEdited: Bool {
        return _stubbedHasTopicsBeenEdited
    }

    var _stubbedHasOnboardedTopics: Bool = false
    var hasOnboardedTopics: Bool {
        return _stubbedHasOnboardedTopics
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
