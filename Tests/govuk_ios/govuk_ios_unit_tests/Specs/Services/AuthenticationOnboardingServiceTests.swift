import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AuthenticationOnboardingServiceTests {
    @Test
    func fetchSlides_returnsExpectedResult() async {
        let sut = AuthenticationOnboardingService()
        let result = await withCheckedContinuation { continuation in
            sut.fetchSlides(
                completion: {
                    continuation.resume(returning: $0)
                }
            )
        }
        switch result {
        case .success(let slides):
            #expect(slides.count == 1)
        default:
            #expect(Bool(false))
        }
    }
    
    @Test
    func isFeatureEnabled_returnsFalse() {
        let sut = AuthenticationOnboardingService()
        #expect(sut.isFeatureEnabled)
    }
}
