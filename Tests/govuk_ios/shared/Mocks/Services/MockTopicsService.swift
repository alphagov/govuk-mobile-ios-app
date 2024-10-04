import Foundation

@testable import govuk_ios

class MockTopicsService: TopicsServiceInterface {
    var _receivedFetchTopicsResult: Result<[Topic], TopicsListError>?
    func fetchTopics(completion: @escaping FetchTopicsListResult) {
        if let result = _receivedFetchTopicsResult {
            completion(result)
        } else {
            completion(.failure(.apiUnavailable))
        }
    }
}

extension MockTopicsService {
    static var testTopicsResult: Result<[Topic], TopicsListError> {
        let topics = [Topic(ref: "driving-transport", title: "Driving & Transport"),
                      Topic(ref: "care", title: "Care"),
                      Topic(ref: "business", title: "Business")
                      ]
        return .success(topics)
    }
    
    static var testTopicsFailure: Result<[Topic], TopicsListError> {
        return .failure(.apiUnavailable)
    }
}
