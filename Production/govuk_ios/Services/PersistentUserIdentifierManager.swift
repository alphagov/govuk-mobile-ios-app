import Foundation
import SecureStore

enum PersistentUserIdentifierError: Error {
    case missingPersistentUserIdentifierError
    case savePersistentUserIdentifierError
}

typealias ReturningUserResult = Result<Bool, PersistentUserIdentifierError>

protocol PersistentUserIdentifierManagerInterface {
    func process(
        authenticationOnboardingFlowSeen: Bool, idToken: String?
    ) async -> ReturningUserResult
}

class PersistentUserIdentifierManager: PersistentUserIdentifierManagerInterface {
    private let openSecureStoreService: SecureStorable

    private func currentPersistentUserIdentifier(idToken: String?) async -> String? {
        guard let idToken = idToken,
              let payload = try? await JWTExtractor().extract(jwt: idToken)
        else {
            return nil
        }
        return payload.sub
    }

    private var storedpersistentUserIdentifier: String? {
        try? openSecureStoreService.readItem(itemName: "persistentUserIdentifier")
    }

    init(openSecureStoreService: SecureStorable) {
        self.openSecureStoreService = openSecureStoreService
    }

    func process(
        authenticationOnboardingFlowSeen: Bool, idToken: String?
    ) async -> ReturningUserResult {
        guard let currentIdentifier = await currentPersistentUserIdentifier(idToken: idToken)
        else {
            return .failure(.missingPersistentUserIdentifierError)
        }

        if authenticationOnboardingFlowSeen {
            guard let storedIdentifier = storedpersistentUserIdentifier
            else {
                return .failure(.missingPersistentUserIdentifierError)
            }
            return await handleUser(
                currentIdentifier: currentIdentifier,
                storedIdentifier: storedIdentifier
            )
        } else {
            return await saveIdentifier(
                currentIdentifier: currentIdentifier, isReturningUser: true
            )
        }
    }

    private func handleUser(
        currentIdentifier: String, storedIdentifier: String
    ) async -> ReturningUserResult {
        if currentIdentifier == storedIdentifier {
            return .success(true)
        } else {
            return await saveIdentifier(
                currentIdentifier: currentIdentifier, isReturningUser: false
            )
        }
    }

    private func saveIdentifier(
        currentIdentifier: String, isReturningUser: Bool
    ) async -> ReturningUserResult {
        do {
            try openSecureStoreService.saveItem(
                item: currentIdentifier,
                itemName: "persistentUserIdentifier"
            )
            return .success(isReturningUser)
        } catch {
            return .failure(.savePersistentUserIdentifierError)
        }
    }
}
