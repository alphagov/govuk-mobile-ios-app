import Foundation

extension Bundle {
    func publicKey(name: String) -> Data? {
        guard let filePath: String = path(forResource: name, ofType: "der"),
            let data: Data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        return data
    }
}
