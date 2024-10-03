import Foundation
import XCTest

@testable import govuk_ios

final class SignableDecoderTestsXC: XCTestCase {
    func test_verifySignature_signatureIsValid_isDecoded() async throws {
        let appConfigData = try XCTUnwrap(getMockConfigData(fileName: "MockAppConfigResponse"), "Unable to read mock data")
        let appConfig = try XCTUnwrap(try? SignableDecoder().decode(AppConfig.self, from: appConfigData), "Unable to decode AppConfig")
        XCTAssertNotNil(appConfig)
    }
    
    func test_verifySignature_signatureMalformed_throwsError() async throws {
        let appConfigData = try XCTUnwrap(getMockConfigData(fileName: "MockAppConfigResponseInvalidSig"), "Unable to read mock data")
        do {
            _ = try SignableDecoder().decode(AppConfig.self, from: appConfigData)
            XCTFail("Expected to fail decoding")
        } catch {
            XCTAssertTrue(error is SigningError)
        }
    }
    
    private func getMockConfigData(fileName: String) -> Data? {
        guard let resourceURL = Bundle.main.url(
            forResource: fileName,
            withExtension: "json"
        ) else { return nil }
        
        return try? Data(contentsOf: resourceURL)
    }
}
