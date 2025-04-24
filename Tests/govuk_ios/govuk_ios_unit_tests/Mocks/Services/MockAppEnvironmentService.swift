import Foundation

@testable import govuk_ios

class MockAppEnvironmentService: AppEnvironmentServiceInterface {
    var authenticationClientId: String = "clientID"
    var baseURL: URL = URL(string: "www.google.com")!
    var oneSignalAppId: String = "one_signal_test"
}
