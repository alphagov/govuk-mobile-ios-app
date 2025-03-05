import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct GOVRequest_AppTests {
    @Test
    func config_returnsExpectedValues() {
        let request = GOVRequest.config

        #expect(request.urlPath == "/config/appinfo/ios")
        #expect(request.method == .get)
        #expect(request.signingKey == Constants.SigningKey.govUK)
        #expect(request.bodyParameters == nil)
        #expect(request.additionalHeaders == nil)
    }
}
