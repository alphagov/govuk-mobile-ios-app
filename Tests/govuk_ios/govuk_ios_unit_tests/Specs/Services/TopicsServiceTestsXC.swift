import Foundation
import XCTest

@testable import govuk_ios

final class TopicsServiceTestsXC: XCTestCase {
    var sut: TopicsService!
    var topicsServiceClient: MockTopicsServiceClient!
    
    override func setUp() {
        super.setUp()
        topicsServiceClient = MockTopicsServiceClient()
        sut = TopicsService(
            topicsServiceClient: topicsServiceClient
        )
    }
    
    override func tearDown() {
        topicsServiceClient = nil
        sut = nil
        super.tearDown()
    }
    
    func test_topicsService_success_returnsExpectedData() async {
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
            topicsServiceClient._receivedFetchTopicsCompletion?(
                MockTopicsService.testTopicsResult
            )
        }
        let topicsList = try? result.get()
        XCTAssertEqual(topicsList?.count, 3)
        // Topics should be sorted
        XCTAssertEqual(topicsList?[0].title, "Business")
        XCTAssertEqual(topicsList?[1].title, "Care")
        XCTAssertEqual(topicsList?[2].title, "Driving & Transport")
    }
    
    func test_topicsService_failure_returnsExpectedResult() async {
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
            topicsServiceClient._receivedFetchTopicsCompletion?(
                MockTopicsService.testTopicsFailure
            )
        }

        XCTAssertNil(try? result.get())
        XCTAssertEqual(result.getError(), .apiUnavailable)
    }

}

