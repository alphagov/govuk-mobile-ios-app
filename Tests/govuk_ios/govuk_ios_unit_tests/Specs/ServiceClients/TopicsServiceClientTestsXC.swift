import Foundation
import XCTest

@testable import govuk_ios

final class TopicsServiceClientTestsXC: XCTestCase {

    var mockAPI: MockAPIServiceClient!
    var sut: TopicsServiceClient!

    override func setUp() {
        super.setUp()
        mockAPI = MockAPIServiceClient()
        sut = TopicsServiceClient(
            serviceClient: mockAPI
        )
    }

    override func tearDown()  {
        mockAPI = nil
        sut = nil
        super.tearDown()
    }

     func test_fetchTopicsList_sendsExpectedRequest() async {
        sut.fetchTopicsList { _ in }
        XCTAssertEqual(mockAPI._receivedSendRequest?.urlPath, "/static/topics/list")
        XCTAssertEqual(mockAPI._receivedSendRequest?.method, .get)
    }
    
     func test_fetchTopicsList_success_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success(Self.topicsListData)
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopicsList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        XCTAssertEqual(topicsList?.count, 5)
        XCTAssertEqual(topicsList?.first?.ref, "driving-transport")
    }
    
     func test_fetchTopicsList_failure_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .failure(TopicsListError.apiUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopicsList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        XCTAssertNil(topicsList)
        XCTAssertEqual(result.getError(), .apiUnavailable)
    }
    
     func test_fetchTopicsList_invalidJson_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success("bad json".data(using: .utf8)!)
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopicsList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        XCTAssertNil(topicsList)
        XCTAssertEqual(result.getError(), .decodingError)
    }
}

private extension TopicsServiceClientTestsXC {
    static let topicsListData =
    """
    [
        {
            "ref": "driving-transport",
            "title": "Driving & Transport"
        },
        {
            "ref": "benefits",
            "title": "Benefits"
        },
        {
            "ref": "care",
            "title": "Care"
        },
        {
            "ref": "parenting",
            "title": "Parenting and guardianship"
        },
        {
            "ref": "business",
            "title": "Business"
        }
    ]
    """.data(using: .utf8)!
}
