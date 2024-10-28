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

    func reregisterSearch(url: URL) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.path = ""
        components?.queryItems = nil
        let newClient = newSearchClient(
            url: components?.url ?? Constants.API.defaultSearchUrl
        )
        searchAPIClient.register { newClient }
    }

    var searchAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            self.newSearchClient(url: Constants.API.defaultSearchUrl)
        }
    }

    private func newSearchClient(url: URL) -> APIServiceClient {
        APIServiceClient(
            baseUrl: url,
            session: URLSession(configuration: .default),
            requestBuilder: RequestBuilder()
        )
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
