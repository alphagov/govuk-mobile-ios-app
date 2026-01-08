import Foundation
import SecureStore

typealias ReturningUserResult = Result<Bool, ReturningUserServiceError>

protocol ReturningUserServiceInterface {
    func process(idToken: String?) async -> ReturningUserResult
}

class ReturningUserService: ReturningUserServiceInterface {
    private let openSecureStoreService: SecureStorable
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let coreDataDeletionService: () -> CoreDataDeletionServiceInterface

    private var storedPersistentUserIdentifier: String? {
        openSecureStoreService.getUserIdentifier()
    }

    init(openSecureStoreService: SecureStorable,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         coreDataDeletionService: @escaping () -> CoreDataDeletionServiceInterface) {
        self.openSecureStoreService = openSecureStoreService
        self.localAuthenticationService = localAuthenticationService
        self.coreDataDeletionService = coreDataDeletionService
    }

    func process(idToken: String?) async -> ReturningUserResult {
        guard let currentIdentifier = await currentPersistentUserIdentifier(idToken: idToken)
        else {
            return .failure(.missingIdentifierError)
        }

        if localAuthenticationService.authenticationOnboardingFlowSeen,
           let storedIdentifier = storedPersistentUserIdentifier {
            return await handleUserIdentifiers(
                currentIdentifier: currentIdentifier,
                storedIdentifier: storedIdentifier
            )
        } else {
            return saveIdentifier(
                currentIdentifier: currentIdentifier,
                isReturningUser: false
            )
        }
    }

    private func currentPersistentUserIdentifier(idToken: String?) async -> String? {
        guard let idToken = idToken,
              let payload = try? await JWTExtractor().extract(jwt: idToken)
        else { return nil }
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
            try coreDataDeletionService().deleteAllObjects()
        } catch {
            return .failure(.coreDataDeletionError)
        }
        return .success(false)
    }

    private func saveIdentifier(currentIdentifier: String,
                                isReturningUser: Bool) -> ReturningUserResult {
        do {
            try openSecureStoreService.saveUserIdentifier(currentIdentifier)
            return .success(isReturningUser)
        } catch {
            return .failure(.saveIdentifierError)
        }
    }
}
