import Foundation

struct LocalAuthoritiesList: Codable,
                             LocalAuthorityType {
    let addresses: [LocalAuthorityAddress]
}
