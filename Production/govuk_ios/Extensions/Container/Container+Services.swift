import Foundation
import UIKit
import Factory
import GOVKit
import UserNotifications

import SecureStore
import Firebase
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

    @MainActor
    var analyticsService: Factory<AnalyticsServiceInterface> {
        Factory(self) {
            self.baseAnalyticsService()
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

    @MainActor
    var baseAnalyticsService: Factory<AnalyticsServiceInterface> {
        Factory(self) {
            AnalyticsService(
                clients: [
                    FirebaseClient(
                        firebaseApp: FirebaseApp.self,
                        firebaseAnalytics: Analytics.self,
                        appAttestService: self.appAttestService()
                    ),
                    CrashlyticsClient(crashlytics: Crashlytics.crashlytics())
                ],
                userDefaultsService: self.userDefaultsService(),
                authenticationService: self.authenticationService.resolve()
            )
        }
        .scope(.singleton)
    }

    @MainActor
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
                appConfigServiceClient: self.appConfigServiceClient.resolve()
            )
        }.scope(.singleton)
    }

    @MainActor
    var topicsService: Factory<TopicsServiceInterface> {
        Factory(self) {
            TopicsService(
                topicsServiceClient: self.topicsServiceClient(),
                topicsRepository: self.topicsRepository(),
                analyticsService: self.analyticsService(),
                userDefaultsService: self.userDefaultsService()
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
                userDefaultsService: self.userDefaultsService(),
                oneSignalInterface: OneSignal.self
            )
        }
    }

    var notificationsOnboardingService: Factory<NotificationsOnboardingServiceInterface> {
        Factory(self) {
            NotificationsOnboardingService(
                userDefaultsService: self.userDefaultsService()
            )
        }
    }

    @MainActor
    var authenticationService: Factory<AuthenticationServiceInterface> {
        Factory(self) {
            AuthenticationService(
                authenticationServiceClient: self.authenticationServiceClient.resolve(),
                authenticatedSecureStoreService: self.authenticatedSecureStoreService.resolve(),
                returningUserService: self.returningUserService.resolve(),
                userDefaultsService: self.userDefaultsService()
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
                coreDataDeletionService: self.coreDataDeletionService.resolve(),
                localAuthenticationService: self.localAuthenticationService.resolve()
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
                userDefaultsService: self.userDefaultsService()
            )
        }
    }

    var coreDataDeletionService: Factory<CoreDataDeletionService> {
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
                appCheckInterface: AppCheck.self,
                providerFactory: self.govuKProviderFactory()
            )
        }.scope(.singleton)
    }

    var govuKProviderFactory: Factory<ProviderFactoryInterface> {
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
        Factory(self) {
            JailbreakDetectionService(
                urlOpener: UIApplication.shared
            )
        }
    }

    var userDefaultsService: Factory<UserDefaultsServiceInterface> {
        Factory(self) {
            UserDefaultsService(userDefaults: .standard)
        }.scope(.singleton)
    }
}
