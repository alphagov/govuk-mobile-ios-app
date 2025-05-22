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

        #expect(request.urlPath == "/api/local-authority")
        #expect(request.method == .get)
        #expect(request.signingKey == nil)
        #expect(request.bodyParameters == nil)
        #expect(request.queryParameters?.count == 1)
        #expect(request.queryParameters?["postcode"] == expectedPostcode)
        #expect(request.additionalHeaders == nil)

    }

    @Test
    func localAuthoritySlug_returnsExpectedValues() async throws {
        let expectedSlug = "dorset"
        let request = GOVRequest.localAuthoritySlug(slug: expectedSlug)

        #expect(request.urlPath == "/api/local-authority/dorset")
        #expect(request.method == .get)
        #expect(request.signingKey == nil)
        #expect(request.bodyParameters == nil)
        #expect(request.queryParameters == nil)
        #expect(request.additionalHeaders == nil)

    }
}
