import Foundation

@testable import govuk_ios

class MockTopicsServiceClient: TopicsServiceClientInterface {
    var _receivedFetchTopicsCompletion: FetchTopicsListResult?
    func fetchTopicsList(completion: @escaping FetchTopicsListResult) {
        _receivedFetchTopicsCompletion = completion
    }

    var _receivedFetchTopicsDetailsTopicRef: String?
    var _receivedFetchTopicsDetailsCompletion: FetchTopicDetailsResult?
    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult) {
        _receivedFetchTopicsDetailsTopicRef = topicRef
        _receivedFetchTopicsDetailsCompletion = completion
    }
}
