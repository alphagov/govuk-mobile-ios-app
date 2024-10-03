import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct AppConfigRepositoryTests {
    let sut: AppConfigRepository

    init() {
        self.sut = AppConfigRepository()
    }

    @Test
    func fetchAppConfig_validFileName_returnsCorrectConfig() async throws {
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                filename: "MockAppConfigResponse",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
        let config = try result.get()
        #expect(config.config.releaseFlags.count == 2)
        #expect(config.config.releaseFlags["search"] == true)
    }

    @Test
    func fetchAppConfig_invalidFileName_returnsError() async throws {
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                filename: "MockResponseInvalidFileName",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let error = result.getError()
        #expect(error == .loadJsonError)
    }

    @Test
    func fetchAppConfig_invalidFileJson_returnsError() async throws {
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                filename: "MockAppConfigResponseInvalid",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let error = result.getError()
        #expect(error == .loadJsonError)
    }
}



