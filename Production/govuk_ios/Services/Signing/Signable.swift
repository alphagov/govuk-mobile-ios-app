import Foundation
import CryptoKit

protocol Signable {
    var signature: String { get }
    func verifySignature(with data: Data) -> Bool
}

extension Signable {
    func verifySignature(signatureBase64: String, data: Data) -> Bool {
        guard let signatureData = Data(base64Encoded: signatureBase64)
        else {
            return false
        }

        guard let publicKeyFile = Bundle.main.publicKey,
              let publicKey = try? P256.Signing.PublicKey(derRepresentation: publicKeyFile)
        else {
            return false
        }

        guard let signatureKey = try? P256.Signing.ECDSASignature(derRepresentation: signatureData)
        else {
            return false
        }

        return publicKey.isValidSignature(signatureKey, for: data)
    }
}
