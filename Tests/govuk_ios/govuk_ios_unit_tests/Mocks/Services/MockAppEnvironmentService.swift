import Foundation

@testable import govuk_ios

class MockAppEnvironmentService: AppEnvironmentServiceInterface {
    var baseURL: URL = URL(string: "www.google.com")!
    var oneSignalAppId: String = "one_signal_test"
    var authenticationClientId: String = "clientID"
    var authenticationAuthorizeURL: URL = URL(string: "www.govuk-auth.com/oauth2/authorize")!
    var authenticationTokenURL: URL = URL(string: "www.govuk-auth.com/oauth2/token")!
}
