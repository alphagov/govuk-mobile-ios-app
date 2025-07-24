import Foundation
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

    @Test
    func authenticationClientId_returnsExpectedValue() {
        let mockConfig = ["AUTHENTICATION_CLIENT_ID": "123456"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.authenticationClientId == "123456")
    }

    @Test
    func authenticationAuthorizeURL_returnsExpectedValue() {
        let mockConfig = ["AUTHENTICATION_BASE_URL": "www.gov.uk"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.authenticationAuthorizeURL ==
                URL(string: "https://www.gov.uk/oauth2/authorize")!)
    }

    @Test
    func authenticationTokenURL_returnsExpectedValue() {
        let mockConfig = ["TOKEN_BASE_URL": "https://www.gov.uk"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.authenticationTokenURL ==
                URL(string: "https://www.gov.uk/oauth2/token")!)
    }

    @Test
    func chatURL_returnsExpectedValue() {
        let mockConfig = ["CHAT_BASE_URL": "www.gov.uk"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.chatBaseURL ==
                URL(string: "https://www.gov.uk/api/v0")!)
    }

    @Test
    func chatAuthToken_returnsExpectedValue() {
        let mockConfig = ["CHAT_AUTH_TOKEN": "123456"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.chatAuthToken == "123456")
    }
}
