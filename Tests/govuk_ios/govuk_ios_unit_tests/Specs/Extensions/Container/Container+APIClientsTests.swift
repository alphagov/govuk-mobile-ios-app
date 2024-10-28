import Foundation
import Testing

import Factory

@testable import govuk_ios

@Suite
struct Container_APIClientTests {
    @Test
    func searchAPIClient_returnsExpectedResult() async {
        Container.shared.reset()
        Container.shared.urlSession.register { URLSession.mock }
        let result = Container.shared.searchAPIClient()

        #expect(result != nil)

        MockURLProtocol.requestHandlers["https://search.service.gov.uk/v0_1/search.json"] = { request in
            #expect(request.url?.absoluteString == "https://www.google.com/test/test")
            #expect(request.httpMethod == "POST")
            let data = request.bodySteamData
            #expect(data != nil)
            let json = try? JSONDecoder().decode([String: String].self, from: data!)
            #expect(json?["test_key"] == "test_value")
            return (.arrangeSuccess, nil, nil)
        }
        let searchRequest = GOVRequest.search(
            term: "test"
        )
        return await withCheckedContinuation { continuation in
            result.send(
                request: searchRequest,
                completion: { _ in
                    continuation.resume(returning: Void())
                }
            )
        }
    }

    @Test
    func searchAPIClient_withConfig_returnsExpectedResult() {
        let result = Container.shared.searchAPIClient()
        #expect(result != nil)
    }
}
