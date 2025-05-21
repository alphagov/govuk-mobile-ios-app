import Foundation

enum LocalAuthorityFlavor {
    case authority(Authority)
    case addressList([LocalAuthorityAddress])
    case errorMessage(String?)
}

struct LocalAuthorityResponse: Codable {
    let localAuthority: Authority?
    let localAuthorityList: [LocalAuthorityAddress]?
    let localAuthorityErrorMessage: String?

    enum CodingKeys: String, CodingKey {
        case localAuthority = "local_authority"
        case localAuthorityList = "addresses"
        case localAuthorityErrorMessage = "message"
    }

    var flavor: LocalAuthorityFlavor {
        switch(localAuthority, localAuthorityList, localAuthorityErrorMessage) {
        case (.some, nil, nil):
            return .authority(localAuthority!)
        case (nil, .some, nil):
            return .addressList(localAuthorityList!)
        default:
            return .errorMessage(localAuthorityErrorMessage)
        }
    }
}
