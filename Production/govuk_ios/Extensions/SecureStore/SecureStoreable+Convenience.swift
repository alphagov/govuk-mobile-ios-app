import Foundation
import SecureStore

// MARK: - Constants
enum SecureStoreableConstant: String {
    case persistentUserIdentifier
    case refreshToken
}

// MARK: - Refresh Token
extension SecureStorable {
    var hasRefreshToken: Bool {
        checkItemExists(
            itemName: SecureStoreableConstant.refreshToken.rawValue
        )
    }

    func getRefreshToken() throws -> String {
        try readItem(
            itemName: SecureStoreableConstant.refreshToken.rawValue
        )
    }

    func saveRefreshToken(_ token: String) throws {
        try saveItem(
            item: token,
            itemName: SecureStoreableConstant.refreshToken.rawValue
        )
    }

    func deleteRefreshToken() {
        deleteItem(
            itemName: SecureStoreableConstant.refreshToken.rawValue
        )
    }
}

// MARK: - User Identifier
extension SecureStorable {
    func getUserIdenitifier() -> String? {
        try? readItem(
            itemName: SecureStoreableConstant.persistentUserIdentifier.rawValue
        )
    }

    func saveUserIdenitifier(_ identifier: String) throws {
        try saveItem(
            item: identifier,
            itemName: SecureStoreableConstant.persistentUserIdentifier.rawValue
        )
    }
}
