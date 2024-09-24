import Foundation
import Testing
@testable import govuk_ios

@Suite
struct SignableDecoderTests {

    @Test
    func verifyValidSignature() async throws {
        let appConfigData = try #require(getMockConfigData(fileName: "MockAppConfigResponse"), "Unable to read mock data")
        let appConfig = try #require(try? SignableDecoder().decode(AppConfig.self, from: appConfigData), "Unable to decode AppConfig")
        #expect(appConfig != nil)
    }
    
    @Test
    func verifyInValidSignature() async throws {
        let appConfigData = try #require(getMockConfigData(fileName: "MockAppConfigResponseInvalidSig"), "Unable to read mock data")
        do {
            _ = try SignableDecoder().decode(AppConfig.self, from: appConfigData)
            #expect(Bool(false), "Expected to fail decoding")
        } catch {
            #expect(error is SigningError)
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
