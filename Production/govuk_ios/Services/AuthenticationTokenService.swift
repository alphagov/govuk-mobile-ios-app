import Foundation
import SecureStore

protocol AuthenticationTokenServiceInterface {
    func encryptRefreshToken() throws
    func decryptRefreshToken() throws
    func deleteTokens()
}

class AuthenticationTokenService: AuthenticationTokenServiceInterface {
    private let secureStoreService: SecureStorable
    private let tokenSet = AuthenticationTokenSet.shared

    init(secureStoreService: SecureStorable) {
        self.secureStoreService = secureStoreService
    }

    func encryptRefreshToken() throws {
        let refreshToken = tokenSet.refreshToken
        guard let refreshToken = refreshToken else {
            throw AuthenticationTokenServiceError.blankRefreshToken
        }

        do {
            try secureStoreService.saveItem(item: refreshToken, itemName: "refreshToken")
        } catch {
            throw error
        }
    }

    func decryptRefreshToken() throws {
        do {
            tokenSet.refreshToken = try secureStoreService.readItem(itemName: "refreshToken")
        } catch {
            throw AuthenticationTokenServiceError.secureStore(error)
        }
    }

    func deleteTokens() {
        secureStoreService.deleteItem(itemName: "refreshToken")
        tokenSet.refreshToken = nil
        tokenSet.idToken = nil
        tokenSet.accessToken = nil
    }
}

enum AuthenticationTokenServiceError: Error {
    case secureStore(Error)
    case blankRefreshToken
}
