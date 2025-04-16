import Foundation

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


    var localAuthorityServiceClient: Factory<LocalAuthorityServiceClientInterface> {
        Factory(self) {
            LocalAuthorityServiceClient(serviceClient: self.localAuthorityAPIClient())
        }
    }
}
