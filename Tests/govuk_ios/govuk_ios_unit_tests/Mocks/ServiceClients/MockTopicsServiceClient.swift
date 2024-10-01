import Foundation

@testable import govuk_ios

class MockTopicsServiceClient: TopicsServiceClientInterface {
    var _receivedFetchTopicsCompletion: FetchTopicsListResult?
    func fetchTopicsList(completion: @escaping FetchTopicsListResult) {
        _receivedFetchTopicsCompletion = completion
    }
}
