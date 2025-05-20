import Foundation

import Factory
import Lottie
import SecureStore

extension Container {
    var lottieConfiguration: Factory<LottieConfiguration> {
        Factory(self) {
            LottieConfiguration.shared
        }
    }

    var accessibilityManager: Factory<AccessibilityManagerInterface> {
        Factory(self) {
            AccessibilityManager()
        }
    }

    var authenticatedSecureStoreConfiguration: Factory<SecureStorageConfiguration> {
        Factory(self) {
            let localAuthStrings = LocalAuthenticationLocalizedStrings(
                localizedReason: String.localAuthentication.localized(
                    "localizedReason"
                ),
                localisedFallbackTitle: String.localAuthentication.localized(
                    "localisedFallbackTitle"
                ),
                localisedCancelTitle: String.common.localized(
                    "cancel"
                )
            )
            #if targetEnvironment(simulator)
            let accessControlLevel =
            SecureStorageConfiguration.AccessControlLevel.open
            #else
            let accessControlLevel =
            SecureStorageConfiguration.AccessControlLevel.currentBiometricsOrPasscode
            #endif
            let config = SecureStorageConfiguration(
                id: "protectedSecureStorage",
                accessControlLevel: accessControlLevel,
                localAuthStrings: localAuthStrings
            )
            return config
        }
    }

    var openSecureStoreConfiguration: Factory<SecureStorageConfiguration> {
        Factory(self) {
            SecureStorageConfiguration(
                id: "openSecureStorage",
                accessControlLevel: SecureStorageConfiguration.AccessControlLevel.open
            )
        }
    }
}
