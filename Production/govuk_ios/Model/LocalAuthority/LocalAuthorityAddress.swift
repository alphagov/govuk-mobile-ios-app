import Foundation

struct LocalAuthorityAddress: Codable {
    let address: String
    let slug: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case address = "address"
        case name = "local_authority_name"
        case slug = "local_authority_slug"
    }
}
