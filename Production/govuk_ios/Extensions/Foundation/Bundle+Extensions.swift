import Foundation

extension Bundle {
    var publicKey: Data? {
        guard let filePath: String = path(forResource: "integration_pubkey", ofType: "der"),
            let data: Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        return data
    }
}
