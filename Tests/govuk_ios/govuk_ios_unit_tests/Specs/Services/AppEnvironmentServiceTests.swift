import Foundation
import Testing
import GOVKit

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
        // Make sure this is nil to return fallback value
        Constants.API.remoteAuthenticationClientID = nil

        let mockConfig = ["AUTHENTICATION_CLIENT_ID": "123456"]
        let sut = AppEnvironmentService(
            config: mockConfig
        )

        #expect(sut.authenticationClientId == "123456")
    }

    @Test
    func authenticationAuthorizeURL_returnsExpectedValue() {
        // Make sure this is nil to return fallback value
        Constants.API.remoteAuthenticationURL = nil

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
}
