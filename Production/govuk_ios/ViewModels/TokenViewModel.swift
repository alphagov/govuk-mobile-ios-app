import Foundation
import SwiftUI
import SecureStore
import UIComponents

class TokenViewModel: ObservableObject {
    private let secureStoreService: SecureStorable

    @Published var token: String = ""
    @Published var encryptedToken: String? = UserDefaults.standard.string(forKey: "Token")
    @Published var decryptedToken: String?

    init(secureStoreService: SecureStorable) {
        self.secureStoreService = secureStoreService
    }

    var encryptButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: "Encrypt") {
            self.encrypt()
        }
    }

    var decryptButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: "Decrypt") {
            self.decrypt()
        }
    }

    var deleteDataButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(localisedTitle: "Delete Token") {
            self.deleteData()
        }
    }

    private func encrypt() {
        do {
            if secureStoreService.checkItemExists(itemName: "Token") {
                encryptedToken = "Item already exists!"
                return
            }
            try secureStoreService.saveItem(item: token, itemName: "Token")
            encryptedToken = UserDefaults.standard.string(forKey: "Token") ?? "Nothing encrypted"
        } catch {
            print("ERROR = \(error)")
            encryptedToken = error.localizedDescription
        }
    }

    private func decrypt() {
        do {
            decryptedToken = try secureStoreService.readItem(itemName: "Token")
        } catch {
            print("ERROR = \(error)")
            decryptedToken = error.localizedDescription
        }
    }

    private func deleteData() {
        secureStoreService.deleteItem(itemName: "Token")
        encryptedToken = UserDefaults.standard.string(forKey: "Token") ?? "Nothing encrypted"
        decryptedToken = ""
    }
}
