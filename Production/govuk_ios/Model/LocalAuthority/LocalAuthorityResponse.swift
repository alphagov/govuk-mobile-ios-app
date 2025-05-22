import Foundation

enum LocalAuthorityResponseType {
    case authority(Authority)
    case addresses([LocalAuthorityAddress])
    case errorMessage(String?)
}

struct LocalAuthorityResponse: Codable {
    let localAuthority: Authority?
    let localAuthorityAddresses: [LocalAuthorityAddress]?
    let localAuthorityErrorMessage: String?

    init(localAuthority: Authority? = nil,
         localAuthorityAddresses: [LocalAuthorityAddress]? = nil,
         localAuthorityErrorMessage: String? = nil) {
        self.localAuthority = localAuthority
        self.localAuthorityAddresses = localAuthorityAddresses
        self.localAuthorityErrorMessage = localAuthorityErrorMessage
    }

    enum CodingKeys: String, CodingKey {
        case localAuthority = "local_authority"
        case localAuthorityAddresses = "addresses"
        case localAuthorityErrorMessage = "message"
    }

    var type: LocalAuthorityResponseType {
        switch(localAuthority, localAuthorityAddresses, localAuthorityErrorMessage) {
        case (.some, nil, nil):
            return .authority(localAuthority!)
        case (nil, .some, nil):
            return .addresses(localAuthorityAddresses!)
        default:
            return .errorMessage(localAuthorityErrorMessage)
        }
    }
}
