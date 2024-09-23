import Foundation
import CryptoKit

enum SigningError: Error {
    case invalidSignature
}

class SignableDecoder {
    private let decoder = JSONDecoder()

    func decode<T: Signable & Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decodedObject = try JSONDecoder().decode(type.self,
                                                     from: data)
        if !decodedObject.verifySignature(with: data) {
            throw SigningError.invalidSignature
        }

        return decodedObject
    }
}
