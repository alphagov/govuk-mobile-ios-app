import Foundation
import Testing

@testable import govuk_ios

@Suite
class AuthenticationCoordinatorTests {
    @Test @MainActor
    func start_startsAuthentication() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController =  MockNavigationController()

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
    }
}
