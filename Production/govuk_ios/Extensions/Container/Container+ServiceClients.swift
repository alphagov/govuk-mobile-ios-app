import Foundation

import Factory

extension Container {
    var govukAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: "https://www.gov.uk")!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }

    var appAPIClient: Factory<APIServiceClientInterface> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: Constants.API.appBaseUrl)!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }
}
