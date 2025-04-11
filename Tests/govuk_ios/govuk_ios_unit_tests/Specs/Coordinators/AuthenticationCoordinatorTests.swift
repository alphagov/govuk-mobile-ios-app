import Foundation
import Testing
import Authentication

@testable import govuk_ios

@Suite
class AuthenticationCoordinatorTests {
    @Test @MainActor
    func start_startsAuthentication() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController =  MockNavigationController()
        let jsonData = """
        {
            "accessToken": "access_token",
            "refreshToken": "refresh_token",
            "idToken": "id_token",
            "tokenType": "id_token",
            "expiryDate": "2099-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!
        let tokenResponse = createTokenResponse(jsonData)
        mockAuthenticationService._stubbedResult = .success(tokenResponse)

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

    private func createTokenResponse(_ jsonData: Data) -> TokenResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let tokenResponse = try? decoder.decode(TokenResponse.self, from: jsonData)
        return tokenResponse!
    }
}
