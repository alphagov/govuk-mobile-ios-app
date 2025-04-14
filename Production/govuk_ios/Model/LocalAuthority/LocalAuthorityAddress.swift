import Foundation

struct LocalAuthorityAddress: Codable,
                              LocalAuthorityType {
    let address: String
    let slug: String
    let name: String
}
