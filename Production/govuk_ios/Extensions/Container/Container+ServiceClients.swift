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

    var govukAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: Constants.API.govukUrlString)!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }

    var searchServiceClient: Factory<SearchServiceClientInterface> {
        Factory(self) {
            SearchServiceClient(
                serviceClient: self.govukAPIClient()
            )
        }
    }
}
