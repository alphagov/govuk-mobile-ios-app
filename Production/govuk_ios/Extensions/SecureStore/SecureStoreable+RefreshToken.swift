import Foundation
import SecureStore

extension SecureStorable {
    var hasRefreshToken: Bool {
        checkItemExists(itemName: "refreshToken")
    }

    func getRefreshToken() throws -> String {
        try readItem(itemName: "refreshToken")
    }

    func saveRefreshToken(_ token: String) throws {
        try saveItem(
            item: token,
            itemName: "refreshToken"
        )
    }

    func deleteRefreshToken() {
        deleteItem(itemName: "refreshToken")
    }
}
