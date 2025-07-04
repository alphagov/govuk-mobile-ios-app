import Foundation
import JWTKit

struct IdTokenPayload: JWTPayload {
    let sub: String
    let email: String
    func verify(using algorithm: some JWTAlgorithm) async throws { /* protocol conformance */ }
}
