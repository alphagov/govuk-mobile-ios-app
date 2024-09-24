import Foundation

struct AppConfig: Decodable {
    let platform: String
    let config: Config
    let signature: String
}

extension AppConfig: Signable {
    func verifySignature(with data: Data) -> Bool {
        guard let dataToValidate = extractDataSliceForKey(CodingKeys.config, from: data) else {
            return false
        }
        return verifySignature(signatureBase64: signature, data: dataToValidate)
    }
}
