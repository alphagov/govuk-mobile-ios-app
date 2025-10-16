import Foundation

@testable import govuk_ios

class MockAppEnvironmentService: AppEnvironmentServiceInterface {
    var baseURL: URL = URL(string: "www.google.com")!
    var oneSignalAppId: String = "one_signal_test"
    var authenticationClientId: String = "clientID"
    var authenticationAuthorizeURL: URL = URL(string: "www.govuk-auth.com/oauth2/authorize")!
    var authenticationTokenURL: URL = URL(string: "www.govuk-auth.com/oauth2/token")!
    var authenticationBaseURL: URL = URL(string: "https://www.govuk-auth.com")!
    var chatBaseURL: URL = URL(string: "https://www.govuk-chat.com")!
    var chatAuthToken: String = "chat_auth_token"
    var tokenBaseURL: URL = URL(string: "https://www.govuk-token.com")!
}
