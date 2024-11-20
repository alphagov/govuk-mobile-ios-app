import Foundation

@testable import govuk_ios

class MockTopicsServiceClient: TopicsServiceClientInterface {
    var _receivedFetchListCompletion: FetchTopicsListCompletion?
    func fetchList(completion: @escaping FetchTopicsListCompletion) {
        _receivedFetchListCompletion = completion
    }

    var _receivedFetchDetailsRef: String?
    var _receivedFetchDetailsCompletion: FetchTopicDetailsCompletion?
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion) {
        _receivedFetchDetailsRef = ref
        _receivedFetchDetailsCompletion = completion
    }
}
