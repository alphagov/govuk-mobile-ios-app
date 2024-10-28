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

    func reregisterSearchAPIClient(url: URL) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.path = ""
        components?.queryItems = nil
        let newClient = newSearchAPIClient(
            url: components?.url ?? Constants.API.defaultSearchUrl
        )
        searchAPIClient.register { newClient }
    }

    var searchAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            self.newSearchAPIClient(url: Constants.API.defaultSearchUrl)
        }
    }

    private func newSearchAPIClient(url: URL) -> APIServiceClient {
        APIServiceClient(
            baseUrl: url,
            session: self.urlSession(),
            requestBuilder: RequestBuilder()
        )
    }

    var urlSession: Factory<URLSession> {
        Factory(self) {
            URLSession(configuration: .default)
        }
    }
}
