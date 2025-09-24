import Foundation
import SecureStore
import GOVKit
import FirebaseCrashlytics

typealias ReturningUserResult = Result<Bool, ReturningUserServiceError>

protocol ReturningUserServiceInterface {
    func process(idToken: String?) async -> ReturningUserResult
}

class ReturningUserService: ReturningUserServiceInterface {
    private let openSecureStoreService: SecureStorable
    private let analyticsService: AnalyticsServiceInterface
    private let coreDataDeletionService: CoreDataDeletionServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface

    private var storedpersistentUserIdentifier: String? {
        Crashlytics.crashlytics().log("get storedpersistentUserIdentifier")
        do {
            return try openSecureStoreService.readItem(itemName: "persistentUserIdentifier")
        } catch {
            Crashlytics.crashlytics().log(error.localizedDescription)
            analyticsService.track(error: error)
            return nil
        }
    }

    init(openSecureStoreService: SecureStorable,
         analyticsService: AnalyticsServiceInterface,
         coreDataDeletionService: CoreDataDeletionServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface) {
        self.openSecureStoreService = openSecureStoreService
        self.analyticsService = analyticsService
        self.coreDataDeletionService = coreDataDeletionService
        self.localAuthenticationService = localAuthenticationService
    }

    func process(idToken: String?) async -> ReturningUserResult {
        Crashlytics.crashlytics().log("ReturningUserService.process called")
        guard let currentIdentifier = await currentPersistentUserIdentifier(idToken: idToken)
        else {
            let error = NSError(
                domain: "uk.gov.govuk",
                code: 1,
                userInfo: [
                    "token": idToken ?? "-"
                ]
            )
            analyticsService.track(error: error)
            return .failure(.missingIdentifierError)
        }

        if localAuthenticationService.authenticationOnboardingFlowSeen {
            guard let storedIdentifier = storedpersistentUserIdentifier
            else {
                let error = NSError(
                    domain: "uk.gov.govuk",
                    code: 2,
                    userInfo: [
                        "token": idToken ?? "-"
                    ]
                )
                analyticsService.track(error: error)
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
        Crashlytics.crashlytics().log("ReturningUserService.currentPersistentUserIdentifier called")
        guard let idToken = idToken else {
            let error = NSError(
                domain: "uk.gov.govuk",
                code: 3
            )
            analyticsService.track(error: error)
            return nil
        }
        guard let payload = try? await JWTExtractor().extract(jwt: idToken) else {
            let error = NSError(
                domain: "uk.gov.govuk",
                code: 4
            )
            analyticsService.track(error: error)
            return nil
        }
        return payload.sub
    }

    private func handleUserIdentifiers(currentIdentifier: String,
                                       storedIdentifier: String) async -> ReturningUserResult {
        Crashlytics.crashlytics().log("ReturningUserService.handleUserIdentifiers called")
        if currentIdentifier == storedIdentifier {
            return .success(true)
        } else {
            return handleNewUser(currentIdentifier: currentIdentifier)
        }
    }

    private func handleNewUser(currentIdentifier: String) -> ReturningUserResult {
        Crashlytics.crashlytics().log("ReturningUserService.handleNewUser called")
        let saveResult = saveIdentifier(
            currentIdentifier: currentIdentifier, isReturningUser: false
        )
        guard case .success = saveResult else {
            return saveResult
        }
        do {
            try coreDataDeletionService.deleteAllObjects()
        } catch {
            analyticsService.track(error: error)
            return .failure(.coreDataDeletionError)
        }
        return .success(false)
    }

    private func saveIdentifier(currentIdentifier: String,
                                isReturningUser: Bool) -> ReturningUserResult {
        Crashlytics.crashlytics().log("ReturningUserService.saveIdentifier called")
        do {
            try openSecureStoreService.saveItem(
                item: currentIdentifier,
                itemName: "persistentUserIdentifier"
            )
            return .success(isReturningUser)
        } catch {
            analyticsService.track(error: error)
            return .failure(.saveIdentifierError)
        }
    }
}

enum ReturningUserServiceError: Error {
    case missingIdentifierError
    case coreDataDeletionError
    case saveIdentifierError
}
