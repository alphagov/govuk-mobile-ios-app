import Foundation
import JWTKit

struct RefreshTokenPayload: JWTPayload {
    let expiryDate: Date
    func verify(using algorithm: some JWTAlgorithm) async throws { /* protocol conformance */ }

    enum CodingKeys: String,
                     CodingKey {
        case expiryDate = "exp"
    }
}
