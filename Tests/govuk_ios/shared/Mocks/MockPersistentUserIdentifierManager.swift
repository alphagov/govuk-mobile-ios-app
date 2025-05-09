import Foundation

@testable import govuk_ios

class MockPersistentUserIdentifierManager: PersistentUserIdentifierManagerInterface {
    let _stubbedReturningUserResult: ReturningUserResult = .success(true)
    func process(authenticationOnboardingFlowSeen: Bool, idToken: String?) async -> govuk_ios.ReturningUserResult {
        _stubbedReturningUserResult
    }
}
