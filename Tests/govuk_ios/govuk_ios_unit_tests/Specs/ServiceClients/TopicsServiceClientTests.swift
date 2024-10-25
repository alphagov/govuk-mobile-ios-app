import Foundation
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

    //MARK: - Fetch Topics List
    @Test
    func fetchList_sendsExpectedRequest() async {
        sut.fetchList() { _ in }
        #expect(mockAPI._receivedSendRequest?.urlPath == "/static/topics/list")
        #expect(mockAPI._receivedSendRequest?.method == .get)
    }
    
    @Test
    func fetchList_success_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success(Self.topicsListData)
        let result = await withCheckedContinuation { continuation in
            sut.fetchList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        #expect(topicsList?.count == 5)
        #expect(topicsList?.first?.ref == "driving-transport")
    }
    
    @Test
    func fetchList_failure_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .failure(TopicsServiceError.apiUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.fetchList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        #expect(topicsList == nil)
        #expect(result.getError() == .apiUnavailable)
    }
    
    @Test
    func fetchList_invalidJson_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success("bad json".data(using: .utf8)!)
        let result = await withCheckedContinuation { continuation in
            sut.fetchList { result in
                continuation.resume(returning: result)
            }
        }
        let topicsList = try? result.get()
        #expect(topicsList == nil)
        #expect(result.getError() == .decodingError)
    }
    
    //MARK: - Fetch Topic Details
    @Test
    func fetchDetails_sendsExpectedRequest() async {
        let expectedTopicRef = UUID().uuidString
        sut.fetchDetails(ref: expectedTopicRef, completion: { _ in })
        #expect(mockAPI._receivedSendRequest?.urlPath == "/static/topics/" + expectedTopicRef)
        #expect(mockAPI._receivedSendRequest?.method == .get)
    }
    
    @Test
    func fetchDetails_success_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success(Self.topicDetailsData)
        let result = await withCheckedContinuation { continuation in
            sut.fetchDetails(ref: "driving-transport") { result in
                continuation.resume(returning:  result)
            }
        }
        let topicDetails = try? result.get()
        #expect(topicDetails?.ref == "driving-transport")
        #expect(topicDetails?.subtopics.count == 7)
        #expect(topicDetails?.content.count == 2)
        #expect(topicDetails?.content.filter { $0.isStepByStep }.count == 1)
        #expect(topicDetails?.content.first?.url.absoluteString == "https://www.gov.uk/learn-to-drive-a-car")
    }
    
    @Test
    func fetchDetails_failure_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .failure(TopicsServiceError.apiUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.fetchDetails(ref: "driving-transport") { result in
                continuation.resume(returning: result)
            }
        }
        let topicDetails = try? result.get()
        #expect(topicDetails == nil)
        #expect(result.getError() == .apiUnavailable)
    }
    
    @Test
    func fetchDetails_invalidJson_returnsExpectedResult() async {
        mockAPI._stubbedSendResponse = .success("bad json".data(using: .utf8)!)
        let result = await withCheckedContinuation { continuation in
            sut.fetchDetails(ref: "driving-transport") { result in
                continuation.resume(returning: result)
            }
        }
        let topicDetails = try? result.get()
        #expect(topicDetails == nil)
        #expect(result.getError() == .decodingError)
    }
}

private extension TopicsServiceClientTests {
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
    
    static let topicDetailsData =
    """
    {
      "ref": "driving-transport",
      "title": "Driving & Transport",
      "subtopics": [
        {
          "ref": "driving",
          "title": "Driving"
        },
        {
          "ref": "driving-abroad",
          "title": "Driving abroad"
        },
        {
          "ref": "learn-to-drive-car",
          "title": "Learning to drive a car, motorbike or mini-bus"
        },
        {
          "ref": "owning-a-vehicle",
          "title": "Owning a vehicle"
        },
        {
          "ref": "losing-the-right-to-drive",
          "title": "Losing the right to drive"
        },
        {
          "ref": "driving-as-a-profession",
          "title": "Driving as a profession or business"
        },
        {
          "ref": "public-transport",
          "title": "Using public transport"
        }
      ],
      "content": [
        {
          "url": "https://www.gov.uk/learn-to-drive-a-car",
          "title": "Learn to drive a car: step by step",
          "description": "Learn to drive a car in the UK - get a provisional licence, take driving lessons, prepare for your theory test, book your practical test",
          "isStepByStep": true,
          "popular": true
        },
        {
          "url": "https://www.gov.uk/view-driving-licence",
          "title": "View or share your driving licence information",
          "description": "Find out what information DVLA holds about your driving licence or create a check code to share your driving record, for example to hire a car ",
          "isStepByStep": false,
          "popular": true
        }
      ]
    }
    """.data(using: .utf8)!
}
