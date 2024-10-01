import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {
    var _receivedFetchTopicsCompletion: FetchTopicsListResult?
    func fetchTopics(completion: @escaping FetchTopicsListResult) {
        _receivedFetchTopicsCompletion = completion
    }
}
