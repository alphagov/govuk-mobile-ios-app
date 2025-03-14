import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct GOVRequest_TopicsTests {
    @Test
    func list_returnsExpectedValues() {
        let request = GOVRequest.topics

        #expect(request.urlPath == "/static/topics/list")
        #expect(request.method == .get)
        #expect(request.signingKey == Constants.SigningKey.govUK)
        #expect(request.bodyParameters == nil)
        #expect(request.additionalHeaders == nil)
    }

    @Test
    func topic_returnsExpectedValues() {
        let expectedRef = UUID().uuidString
        let request = GOVRequest.topic(ref: expectedRef)

        #expect(request.urlPath == "/static/topics/\(expectedRef)")
        #expect(request.method == .get)
        #expect(request.signingKey == Constants.SigningKey.govUK)
        #expect(request.bodyParameters == nil)
        #expect(request.queryParameters == nil)
        #expect(request.additionalHeaders == nil)
    }
}
