import Foundation

@testable import govuk_ios

class MockTopicsServiceClient: TopicsServiceClientInterface {
    var _receivedFetchListCompletion: FetchTopicsListResult?
    func fetchList(completion: @escaping FetchTopicsListResult) {
        _receivedFetchListCompletion = completion
    }

    var _receivedFetchDetailsRef: String?
    var _receivedFetchDetailsCompletion: FetchTopicDetailsResult?
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsResult) {
        _receivedFetchDetailsRef = ref
        _receivedFetchDetailsCompletion = completion
    }
}
