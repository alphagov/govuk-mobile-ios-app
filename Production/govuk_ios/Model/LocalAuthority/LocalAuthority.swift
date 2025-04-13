import Foundation

import Foundation

struct LocalAuthority: Codable,
                       LocalAuthorityType {
    let localAuthority: Authority

    enum CodingKeys: String, CodingKey {
        case localAuthority = "local_authority"
    }
}
