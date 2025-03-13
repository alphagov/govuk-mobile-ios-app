import Foundation
import SwiftUI
import SecureStore
import UIComponents

class TokenViewModel: ObservableObject {
    private let secureStoreService: SecureStorable

    @Published var token: String = ""
    @Published var encryptedToken: String = ""
    @Published var decryptedToken: String = ""

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

    func encrypt() {
        do {
            try secureStoreService.saveItem(item: token, itemName: "Token")
            encryptedToken = UserDefaults.standard.string(forKey: "Token") ?? "No token found"
        } catch {
            print("ERROR = \(error)")
            encryptedToken = error.localizedDescription
        }
    }

    func decrypt() {
        do {
            decryptedToken = try secureStoreService.readItem(itemName: "Token")
        } catch {
            print("ERROR = \(error)")
            decryptedToken = error.localizedDescription
        }
    }
}
