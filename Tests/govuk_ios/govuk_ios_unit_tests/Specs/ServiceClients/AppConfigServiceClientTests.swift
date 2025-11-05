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
            serviceClient: mockServiceClient
        )
    }

    @Test
    func fetchAppConfig_sendsRequest() {
            sut.fetchAppConfig(
                completion: { _ in }
            )
        #expect(mockServiceClient._receivedSendRequest?.urlPath == "/config/appinfo/ios")
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
        #expect(unwrappedResult.config.releaseFlags.count == 9)
        #expect(unwrappedResult.config.releaseFlags["search"] == true)
        #expect(unwrappedResult.config.chatUrls?.termsAndConditions != nil)
        #expect(unwrappedResult.config.alertBanner?.id  == "govuk_alert_emergency_notification_2025")
        #expect(unwrappedResult.config.alertBanner?.link?.title
                == "About emergency alerts")
        #expect(unwrappedResult.config.chatBanner?.id  == "govuk_chat_banner_09_2025")
        #expect(unwrappedResult.config.chatBanner?.link.title
                == "Ask a question")
        #expect(unwrappedResult.config.userFeedbackBanner?.link.title  == "Give feedback")
        #expect(unwrappedResult.config.emergencyBanners?.count == 2)
        #expect(unwrappedResult.config.emergencyBanners?.first?.id == "national_emergency_one")
        #expect(unwrappedResult.config.emergencyBanners?.first?.title == "National Emergency")
        #expect(unwrappedResult.config.emergencyBanners?.first?.type == "national-emergency")
        #expect(unwrappedResult.config.emergencyBanners?.last?.link?.title == "More Information")
        #expect(unwrappedResult.config.emergencyBanners?.last?.allowsDismissal == false)
    }

    @Test
    func fetchAppConfig_invalidJson_returnsError() async {
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
    func fetchAppConfig_invalidJSON_returnsError() async {
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
        let result = await withCheckedContinuation { continuation in
            sut.fetchAppConfig(
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
            mockServiceClient._receivedSendCompletion?(.failure(SigningError.invalidSignature))
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

