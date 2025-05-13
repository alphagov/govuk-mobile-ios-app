import Foundation
import Factory
import Onboarding
import GOVKit

import SecureStore
import Firebase
import FirebaseCrashlytics

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
            self.baseAnalyticsService()
        }
    }

    var onboardingAnalyticsService: Factory<OnboardingAnalyticsService> {
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

    var baseAnalyticsService: Factory<AnalyticsServiceInterface & OnboardingAnalyticsService> {
        Factory(self) {
            AnalyticsService(
                clients: [
                    FirebaseClient(
                        firebaseApp: FirebaseApp.self,
                        firebaseAnalytics: Analytics.self
                    ),
                    CrashlyticsClient(crashlytics: Crashlytics.crashlytics())
                ],
                userDefaults: UserDefaults.standard
            )
        }
        .scope(.singleton)
    }

    var appLaunchService: Factory<AppLaunchServiceInterface> {
        Factory(self) {
            AppLaunchService(
                configService: self.appConfigService.resolve(),
                topicService: self.topicsService.resolve()
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

    var onboardingService: Factory<OnboardingServiceInterface> {
        Factory(self) {
            OnboardingService(
                userDefaults: UserDefaults.standard
            )
        }
    }

    var topicsService: Factory<TopicsServiceInterface> {
        Factory(self) {
            TopicsService(
                topicsServiceClient: self.topicsServiceClient(),
                topicsRepository: self.topicsRepository(),
                analyticsService: self.analyticsService(),
                userDefaults: UserDefaults.standard
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
                notificationCenter: UNUserNotificationCenter.current()
            )
        }
    }

    var authenticationOnboardingService: Factory<AuthenticationOnboardingServiceInterface> {
        Factory(self) {
            AuthenticationOnboardingService()
        }
    }

    @MainActor
    var authenticationService: Factory<AuthenticationServiceInterface> {
        Factory(self) {
            AuthenticationService(
                authenticationServiceClient: self.authenticationServiceClient.resolve(),
                authenticatedSecureStoreService: self.authenticatedSecureStoreService.resolve(),
                persistentUserIdentifierManager: self.persistentUserIdentifierManager.resolve(),
                userDefaults: UserDefaults.standard
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

    var persistentUserIdentifierManager: Factory<PersistentUserIdentifierManagerInterface> {
        Factory(self) {
            PersistentUserIdentifierManager(
                openSecureStoreService: self.openSecureStoreService.resolve()
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
                userDefaults: UserDefaults.standard
            )
        }
    }

    var coreDataDeletionService: Factory<CoreDataDeletionService> {
        Factory(self) {
            CoreDataDeletionService(
                coreDataRespository: self.coreDataRepository.resolve()
            )
        }
    }
}
