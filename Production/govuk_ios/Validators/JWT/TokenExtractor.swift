import Foundation
import JWTKit

protocol TokenExtractor {
    func extract(jwt: String) async throws -> IdTokenPayload
}

struct JWTExtractor: TokenExtractor {
    let signers = JWTKeyCollection()

    func extract(jwt: String) async throws -> IdTokenPayload {
        return try await signers.unverified(jwt)
    }
}
