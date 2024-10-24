import Foundation

import Factory

extension Container {
    var appAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: Constants.API.appBaseUrl)!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }

    var searchAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            let searchApiUrl = self.appConfigService().searchApiUrl
            let components = URLComponents(string: searchApiUrl)!
            let baseUrl = components.scheme! + "://" + components.host!

            return APIServiceClient(
                baseUrl: URL(string: baseUrl)!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }

    var searchServiceClient: Factory<SearchServiceClientInterface> {
        Factory(self) {
            SearchServiceClient(
                serviceClient: self.searchAPIClient()
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
}
