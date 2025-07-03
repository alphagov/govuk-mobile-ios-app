import Foundation
import SecureStore

typealias ReturningUserResult = Result<Bool, ReturningUserServiceError>

protocol ReturningUserServiceInterface {
    func process(idToken: String?) async -> ReturningUserResult
}

class ReturningUserService: ReturningUserServiceInterface {
    private let openSecureStoreService: SecureStorable
    private let coreDataDeletionService: CoreDataDeletionServiceInterface
    private let userDefaults: UserDefaultsInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface

    private var storedpersistentUserIdentifier: String? {
        try? openSecureStoreService.readItem(itemName: "persistentUserIdentifier")
    }

    init(openSecureStoreService: SecureStorable,
         coreDataDeletionService: CoreDataDeletionServiceInterface,
         userDefaults: UserDefaultsInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface) {
        self.openSecureStoreService = openSecureStoreService
        self.coreDataDeletionService = coreDataDeletionService
        self.userDefaults = userDefaults
        self.localAuthenticationService = localAuthenticationService
    }

    func process(idToken: String?) async -> ReturningUserResult {
        guard let currentIdentifier = await currentPersistentUserIdentifier(idToken: idToken)
        else {
            return .failure(.missingIdentifierError)
        }

        if localAuthenticationService.authenticationOnboardingFlowSeen {
            guard let storedIdentifier = storedpersistentUserIdentifier
            else {
                return .failure(.missingIdentifierError)
            }
            return await handleUserIdentifiers(
                currentIdentifier: currentIdentifier,
                storedIdentifier: storedIdentifier
            )
        } else {
            return saveIdentifier(currentIdentifier: currentIdentifier, isReturningUser: true)
        }
    }

    private func currentPersistentUserIdentifier(idToken: String?) async -> String? {
        guard let idToken = idToken,
              let payload = try? await JWTExtractor().extract(jwt: idToken)
        else {
            return nil
        }
        return payload.sub
    }

    private func handleUserIdentifiers(currentIdentifier: String,
                                       storedIdentifier: String) async -> ReturningUserResult {
        if currentIdentifier == storedIdentifier {
            return .success(true)
        } else {
            return handleNewUser(currentIdentifier: currentIdentifier)
        }
    }

    private func handleNewUser(currentIdentifier: String) -> ReturningUserResult {
        let saveResult = saveIdentifier(
            currentIdentifier: currentIdentifier, isReturningUser: false
        )
        guard case .success = saveResult else {
            return saveResult
        }
        do {
            try coreDataDeletionService.deleteAllObjects()
        } catch {
            return .failure(.coreDataDeletionError)
        }
        return .success(false)
    }

    private func saveIdentifier(currentIdentifier: String,
                                isReturningUser: Bool) -> ReturningUserResult {
        do {
            try openSecureStoreService.saveItem(
                item: currentIdentifier,
                itemName: "persistentUserIdentifier"
            )
            return .success(isReturningUser)
        } catch {
            return .failure(.saveIdentifierError)
        }
    }
}

enum ReturningUserServiceError: Error {
    case missingIdentifierError
    case coreDataDeletionError
    case saveIdentifierError
}
