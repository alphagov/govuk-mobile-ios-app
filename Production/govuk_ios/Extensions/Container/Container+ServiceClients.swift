import Foundation
import Authentication
import AppAuth

import FactoryKit

extension Container {
    var appConfigServiceClient: Factory<AppConfigServiceClientInterface> {
        Factory(self) {
            AppConfigServiceClient(
                serviceClient: self.appAPIClient()
            )
        }
    }

    var remoteConfigServiceClient: Factory<RemoteConfigServiceClientInterface> {
        Factory(self) {
            RemoteConfigServiceClient(
                remoteConfig: self.remoteConfig()
            )
        }
    }

    var searchServiceClient: Factory<SearchServiceClientInterface> {
        Factory(self) {
            SearchServiceClient(
                serviceClient: self.searchAPIClient(),
                suggestionsServiceClient: self.govukAPIClient()
            )
        }
    }

    var topicsServiceClient: Factory<TopicsServiceClientInterface> {
        Factory(self) {
            TopicsServiceClient(
                serviceClient: self.appAPIClient()
            )
        }
    }

    var authenticationServiceClient: Factory<AuthenticationServiceClientInterface> {
        Factory(self) {
            AuthenticationServiceClient(
                appEnvironmentService: self.appEnvironmentService.resolve(),
                appAuthSession: AppAuthSessionWrapper(),
                oidAuthService: OIDAuthorizationServiceWrapper(),
                revokeTokenServiceClient: self.revokeTokenAPIClient(),
                appAttestService: self.appAttestService.resolve(),
            )
        }
    }

    var localAuthorityServiceClient: Factory<LocalAuthorityServiceClientInterface> {
        Factory(self) {
            LocalAuthorityServiceClient(
                serviceClient: self.localAuthorityAPIClient()
            )
        }
    }

    var chatServiceClient: Factory<ChatServiceClientInterface> {
        Factory(self) {
            ChatServiceClient(
                serviceClient: self.chatAPIClient(),
                authenticationService: self.authenticationService.resolve()
            )
        }
    }
}
