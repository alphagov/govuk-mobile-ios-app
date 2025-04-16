import Foundation

@testable import govuk_ios

final class MockLocalAuthorityRepository: LocalAuthorityRepositoryInterface {
    var _didSaveLocalAuthority = false
    func save(_ localAuthority: LocalAuthority) {
        _didSaveLocalAuthority = true
    }

    var _didFetchLocalAuthority = false
    func fetchLocalAuthority() -> [LocalAuthorityItem] {
        _didFetchLocalAuthority = true
        return []
    }
}
