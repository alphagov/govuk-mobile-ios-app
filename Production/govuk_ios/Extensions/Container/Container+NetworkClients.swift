import Foundation

import Factory

extension Container {
    var apiClient: Factory<APIServiceClient> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: "https://www.gov.uk")!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }
}
