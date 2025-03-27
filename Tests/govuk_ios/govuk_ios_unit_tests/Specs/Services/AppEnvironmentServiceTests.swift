import Testing
@testable import govuk_ios

@Suite
struct AppEnvironmentServiceTests {

    @Test
    func baseURL_returnsExpectedValue() {
        let mockConfig = ["BaseURL": "https://www.example.com"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.baseURL.absoluteString == "https://www.example.com")
    }

    @Test
    func oneSignalAppID_returnsExpectedValue() {
        let mockConfig = ["ONESIGNAL_APP_ID": "123456"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.oneSignalAppId == "123456")
    }
}
