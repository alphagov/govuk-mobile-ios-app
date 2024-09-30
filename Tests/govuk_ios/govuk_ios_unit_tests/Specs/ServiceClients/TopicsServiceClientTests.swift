import Testing

@testable import govuk_ios

@Suite
struct TopicsServiceClientTests {
    
    
    var mockAPI: MockAPIServiceClient!
    var sut: TopicsServiceClient!
    
    init() {
        mockAPI = MockAPIServiceClient()
        sut = TopicsServiceClient(
            serviceClient: mockAPI
        )
    }

    @Test func fetchTopicsList_sendsExpectedRequest() async {
        sut.fetchTopicsList { _ in }
        #expect(mockAPI._receivedSendRequest?.urlPath == "/static/topics/list")
        #expect(mockAPI._receivedSendRequest?.method == .get)
    }
    
    @Test func fetchTopicsList_success_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success(Self.topicsListData)
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopicsList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        #expect(topicsList?.count == 5)
        #expect(topicsList?.first?.ref == "driving-transport")
    }
    
    @Test func fetchTopicsList_failure_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .failure(TopicsListError.apiUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopicsList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        #expect(topicsList == nil)
        #expect(result.getError() == .apiUnavailable)
    }
    
    @Test func fetchTopicsList_invalidJson_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success("bad json".data(using: .utf8)!)
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopicsList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        #expect(topicsList == nil)
        #expect(result.getError() == .decodingError)
    }
}

extension TopicsServiceClientTests {
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
