import Foundation

@testable import govuk_ios

class MockTopicsServiceClient: TopicsServiceClientInterface {
    var _receivedFetchTopicsCompletion: FetchTopicsListResult?
    func fetchTopicsList(completion: @escaping FetchTopicsListResult) {
        _receivedFetchTopicsCompletion = completion
    }
    var _receivedFetchTopicsDetailsCompletion: FetchTopicDetailsResult?
    func fetchTopicDetails(for topicRef: String,
                           completion: @escaping FetchTopicDetailsResult) {
        _receivedFetchTopicsDetailsCompletion = completion
    }
}
