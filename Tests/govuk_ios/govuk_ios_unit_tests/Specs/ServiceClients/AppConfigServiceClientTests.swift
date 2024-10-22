import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct AppConfigServiceClientTests {
    let sut: AppConfigServiceClient
    let mockServiceClient: MockAPIServiceClient

    init() {
        mockServiceClient = MockAPIServiceClient()
        sut = AppConfigServiceClient(
            serviceClient: mockServiceClient,
            decoder: SignableDecoder()
        )
    }

    @Test
    func fetchAppConfig_validJson_returnsCorrectConfig() async throws {
        let mockJsonData = getJsonData(filename: "MockAppConfigResponse", bundle: .main)
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockServiceClient._receivedSendCompletion?(.success(mockJsonData))
        }
        let unwrappedResult = try result.get()
        #expect(unwrappedResult.config.releaseFlags.count == 2)
        #expect(unwrappedResult.config.releaseFlags["search"] == true)
    }

    @Test
    func fetchAppConfig_invalidJson_returnsError() async throws {
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockServiceClient._receivedSendCompletion?(.failure(TestError.fakeNetwork))
        }

        let error = result.getError()
        #expect(error == AppConfigError.remoteJson)
    }

    @Test
    func fetchAppConfig_invalidJSON_returnsError() async throws {
        let mockJsonData = getJsonData(filename: "MockAppConfigResponseInvalid", bundle: .main)
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockServiceClient._receivedSendCompletion?(.success(mockJsonData))
        }
        let unwrappedResult = result.getError()
        #expect(unwrappedResult == AppConfigError.remoteJson)
    }

    @Test
    func fetchAppConfig_invalidSignature_returnsError() async throws {
        let mockJsonData = getJsonData(filename: "MockAppConfigResponseInvalidSig", bundle: .main)
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockServiceClient._receivedSendCompletion?(.success(mockJsonData))
        }
        let unwrappedResult = result.getError()
        #expect(unwrappedResult == AppConfigError.invalidSignature)
    }

    private func getJsonData(filename: String, bundle: Bundle) -> Data {
        let resourceURL = bundle.url(
            forResource: filename,
            withExtension: "json"
        )
        guard let resourceURL = resourceURL else {
            return Data()
        }
        do {
            return try Data(contentsOf: resourceURL)
        } catch {
            return Data()
        }
    }
}

