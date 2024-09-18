import Foundation

import Factory

extension Container {
    var searchServiceClient: Factory<SearchServiceClientInterface> {
        Factory(self) {
            SearchServiceClient(
                serviceClient: self.govukAPIClient()
            )
        }
    }

    var govukAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: "https://www.gov.uk")!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }
}
