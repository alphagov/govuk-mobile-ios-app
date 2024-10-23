import Foundation

extension Data {

    static func load(filename: String,
                     bundle: Bundle = .main) -> Data {
        let resourceURL = bundle.url(
            forResource: filename,
            withExtension: "json"
        )
        guard let resourceURL = resourceURL else {
            return Data()
        }
        do {
            return try Data(contentsOf: resourceURL)
        } catch {
            return Data()
        }
    }

}
