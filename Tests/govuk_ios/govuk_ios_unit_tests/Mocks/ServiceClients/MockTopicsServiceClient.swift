import Foundation

@testable import govuk_ios

class MockTopicsServiceClient: TopicsServiceClientInterface {
    var _receivedFetchTopicsCompletion: FetchTopicsListResult?
    func fetchList(completion: @escaping FetchTopicsListResult) {
        _receivedFetchTopicsCompletion = completion
    }

    var _receivedFetchTopicsDetailsTopicRef: String?
    var _receivedFetchTopicsDetailsCompletion: FetchTopicDetailsResult?
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsResult) {
        _receivedFetchTopicsDetailsTopicRef = ref
        _receivedFetchTopicsDetailsCompletion = completion
    }
}
