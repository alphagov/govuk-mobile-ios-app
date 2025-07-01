import Foundation

enum LocalAuthorityResponseType {
    case authority(Authority)
    case addresses([LocalAuthorityAddress])
    case unknown
}

struct LocalAuthorityResponse: Codable {
    let localAuthority: Authority?
    let localAuthorityAddresses: [LocalAuthorityAddress]?

    init(localAuthority: Authority? = nil,
         localAuthorityAddresses: [LocalAuthorityAddress]? = nil) {
        self.localAuthority = localAuthority
        self.localAuthorityAddresses = localAuthorityAddresses
    }

    enum CodingKeys: String, CodingKey {
        case localAuthority = "local_authority"
        case localAuthorityAddresses = "addresses"
    }

    var type: LocalAuthorityResponseType {
        switch(localAuthority, localAuthorityAddresses) {
        case (.some, nil):
            return .authority(localAuthority!)
        case (nil, .some):
            return .addresses(localAuthorityAddresses!)
        default:
            return .unknown
        }
    }
}
