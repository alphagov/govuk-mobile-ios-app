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

    var secureStoreConfiguration: Factory<SecureStorageConfiguration> {
        Factory(self) {
            let localAuthStrings = LocalAuthenticationLocalizedStrings(
                localizedReason: "Enter Passcode to access your saved data",
                localisedFallbackTitle: "Enter Passcode",
                localisedCancelTitle: "Cancel"
            )
            let accessControlLevel =
            SecureStorageConfiguration.AccessControlLevel.currentBiometricsOrPasscode
            let config = SecureStorageConfiguration(
                id: "GOVUK",
                accessControlLevel: accessControlLevel,
                localAuthStrings: localAuthStrings
            )
            return config
        }
    }
}
