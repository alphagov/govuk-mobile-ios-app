import Foundation
import UIKit
import FactoryKit
import GOVKit
import UserNotifications

import SecureStore
import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseAppCheck
import OneSignalFramework

extension Container {
    var activityService: Factory<ActivityServiceInterface> {
        Factory(self) {
            ActivityService(
                repository: self.activityRepository()
            )
        }
    }

    var analyticsService: Factory<AnalyticsServiceInterface> {
        Factory(self) {
            AnalyticsService(
                clients: [
                    self.firebaseClient.resolve(),
                    self.crashlyticsClient.resolve()
                ],
                userDefaultsService: self.userDefaultsService.resolve(),
                isSignedIn: {
                    self.authenticationService.resolve().isSignedIn
                }
            )
        }
        .scope(.singleton)
    }

    var firebaseClient: Factory<AnalyticsClient> {
        Factory(self) {
            // Required here because it needs to be set before configure is called
            AppCheck.setAppCheckProviderFactory(self.govuKProviderFactory.resolve())
            return FirebaseClient(
                firebaseApp: FirebaseApp.self,
                firebaseAnalytics: Analytics.self,
            )
        }
    }

    var crashlyticsClient: Factory<AnalyticsClient> {
        Factory(self) {
            CrashlyticsClient(crashlytics: Crashlytics.crashlytics())
        }
    }

    var searchService: Factory<SearchServiceInterface> {
        Factory(self) {
            SearchService(
                serviceClient: self.searchServiceClient(),
                repository: self.searchHistoryRepository()
            )
        }
    }

    var localAuthorityService: Factory<LocalAuthorityServiceInterface> {
        Factory(self) {
            LocalAuthorityService(
                serviceClient: self.localAuthorityServiceClient(),
                repository: self.localAuthorityRepository()
            )
        }
    }

    var appLaunchService: Factory<AppLaunchServiceInterface> {
        Factory(self) {
            AppLaunchService(
                configService: self.appConfigService.resolve(),
                topicService: self.topicsService.resolve(),
                notificationService: self.notificationService.resolve()
            )
        }.scope(.singleton)
    }

    var appConfigService: Factory<AppConfigServiceInterface> {
        Factory(self) {
            AppConfigService(
                appConfigServiceClient: self.appConfigServiceClient.resolve(),
                analyticsService: self.analyticsService.resolve()
            )
        }.scope(.singleton)
    }
    var topicsService: Factory<TopicsServiceInterface> {
        Factory(self) {
            TopicsService(
                topicsServiceClient: self.topicsServiceClient(),
                analyticsService: self.analyticsService(),
                userDefaultsService: self.userDefaultsService.resolve(),
                topicsRepository: {
                    self.topicsRepository.resolve()
                }
            )
        }
    }

    var appEnvironmentService: Factory<AppEnvironmentServiceInterface> {
        Factory(self) {
            guard let config = Bundle.main.infoDictionary else {
                fatalError("Info.plist not found")
            }
            return AppEnvironmentService(
                config: config
            )
        }.scope(.singleton)
    }

    var notificationService: Factory<NotificationServiceInterface> {
        Factory(self) {
            NotificationService(
                environmentService: self.appEnvironmentService.resolve(),
                notificationCenter: UNUserNotificationCenter.current(),
                configService: self.appConfigService.resolve(),
                userDefaultsService: self.userDefaultsService.resolve(),
                oneSignalServiceClient: OneSignal.self
            )
        }
    }

    var notificationsOnboardingService: Factory<NotificationsOnboardingServiceInterface> {
        Factory(self) {
            NotificationsOnboardingService(
                userDefaultsService: self.userDefaultsService.resolve()
            )
        }
    }

    var authenticationService: Factory<AuthenticationServiceInterface> {
        Factory(self) {
            AuthenticationService(
                authenticationServiceClient: self.authenticationServiceClient.resolve(),
                authenticatedSecureStoreService: self.authenticatedSecureStoreService.resolve(),
                returningUserService: self.returningUserService.resolve(),
                userDefaultsService: self.userDefaultsService.resolve(),
                analyticsService: self.analyticsService.resolve(),
                appConfigService: self.appConfigService.resolve(),
            )
        }.scope(.singleton)
    }

    var authenticatedSecureStoreService: Factory<SecureStorable> {
        Factory(self) {
            SecureStoreService(
                configuration: self.authenticatedSecureStoreConfiguration.resolve()
            )
        }
    }

    var returningUserService: Factory<ReturningUserServiceInterface> {
        Factory(self) {
            ReturningUserService(
                openSecureStoreService: self.openSecureStoreService.resolve(),
                localAuthenticationService: self.localAuthenticationService.resolve(),
                coreDataDeletionService: {
                    self.coreDataDeletionService.resolve()
                }
            )
        }
    }

    var openSecureStoreService: Factory<SecureStorable> {
        Factory(self) {
            SecureStoreService(
                configuration: self.openSecureStoreConfiguration.resolve()
            )
        }
    }

    var localAuthenticationService: Factory<LocalAuthenticationServiceInterface> {
        Factory(self) {
            LocalAuthenticationService(
                userDefaultsService: self.userDefaultsService.resolve()
            )
        }
    }

    var coreDataDeletionService: Factory<CoreDataDeletionServiceInterface> {
        Factory(self) {
            CoreDataDeletionService(
                coreDataRepository: self.coreDataRepository.resolve()
            )
        }
    }

    @MainActor
    var inactivityService: Factory<InactivityServiceInterface> {
        Factory(self) {
            InactivityService(
                authenticationService: self.authenticationService.resolve(),
                timer: TimerWrapper()
            )
        }.scope(.singleton)
    }

    var appAttestService: Factory<AppAttestServiceInterface> {
        Factory(self) {
            AppAttestService(
                appCheckInterface: AppCheck.appCheck(),
                analyticsService: self.analyticsService.resolve()
            )
        }.scope(.singleton)
    }

    var govuKProviderFactory: Factory<AppCheckProviderFactory> {
        Factory(self) {
            GovUKProviderFactory()
        }
    }

    var chatService: Factory<ChatServiceInterface> {
        Factory(self) {
            ChatService(
                serviceClient: self.chatServiceClient.resolve(),
                chatRepository: self.chatRepository.resolve(),
                configService: self.appConfigService.resolve(),
                userDefaultsService: self.userDefaultsService.resolve()
            )
        }
    }

    var jailbreakDetectionService: Factory<JailbreakDetectionServiceInterface> {
        let application = UIApplication.shared
        return Factory(self) {
            JailbreakDetectionService(
                urlOpener: application
            )
        }
    }

    var userDefaultsService: Factory<UserDefaultsServiceInterface> {
        Factory(self) {
            UserDefaultsService(userDefaults: .standard)
        }.scope(.singleton)
    }

    var privacyService: Factory<PrivacyPresenting?> {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
        return Factory(self) {
            sceneDelegate as? PrivacyPresenting
        }
    }
}
