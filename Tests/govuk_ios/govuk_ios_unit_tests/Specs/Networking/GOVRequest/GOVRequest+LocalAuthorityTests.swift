import Testing
import GOVKit
import Foundation

@testable import govuk_ios

@Suite
struct GOVRequest_LocalAuthorityTests {

    @Test
    func localAuthority_returnsExpectedValues() async throws {
        let expectedPostcode = "SW1A 0AA"
        let request = GOVRequest.localAuthority(postcode: expectedPostcode)

        #expect(request.urlPath == "/find-local-council/query.json")
        #expect(request.method == .get)
        #expect(request.signingKey == nil)
        #expect(request.bodyParameters == nil)
        #expect(request.queryParameters?.count == 1)
        #expect(request.queryParameters?["postcode"] == expectedPostcode)
        #expect(request.additionalHeaders == nil)

    }
}
