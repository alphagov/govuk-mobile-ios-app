import Foundation

import Factory

extension Container {
    var govukAPIClient: Factory<APIServiceClient> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: "https://www.gov.uk")!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }
}