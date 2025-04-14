import Foundation
import Authentication
import AppAuth

import Factory

extension Container {
    var appConfigServiceClient: Factory<AppConfigServiceClientInterface> {
        Factory(self) {
            AppConfigServiceClient(
                serviceClient: self.appAPIClient()
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

    @MainActor
    var authenticationServiceClient: Factory<AuthenticationServiceClient> {
        Factory(self) {
            return AuthenticationServiceClient(
                appEnvironmentService: self.appEnvironmentService.resolve(),
                appAuthSession: AppAuthSessionWrapper(),
                oidConfigService: OIDAuthorizationServiceWrapper()
            )
        }
    }
}
