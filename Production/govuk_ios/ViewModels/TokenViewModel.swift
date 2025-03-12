import Foundation
import SwiftUI
import SecureStore

struct TokenViewModel {
    private let secureStoreService: SecureStorable

    init(secureStoreService: SecureStorable) {
        self.secureStoreService = secureStoreService
    }
}
