import Foundation

import Factory

extension Container {
    var apiClient: Factory<APIServiceClient> {
        Factory(self) {
            APIServiceClient(
                baseUrl: URL(string: "dsgljksdfg")!,
                session: URLSession(configuration: .default),
                requestBuilder: RequestBuilder()
            )
        }
    }
}
