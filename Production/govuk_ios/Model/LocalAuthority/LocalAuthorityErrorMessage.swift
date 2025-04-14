import Foundation

struct LocalErrorMessage: LocalAuthorityType,
                          Codable {
    let message: String
}
