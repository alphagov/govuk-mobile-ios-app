import Foundation
import Testing

import Factory

@testable import govuk_ios

@Suite
struct Container_APIClientTests {
    @Test
    func searchAPIClient_createsExpectedRequest() async {
        Container.shared.reset()
        Container.shared.urlSession.register { URLSession.mock }
        let sut = Container.shared.searchAPIClient()

        #expect(sut != nil)
        return await withCheckedContinuation { continuation in

            MockURLProtocol.requestHandlers["https://search.service.gov.uk/v0_1/search.json"] = { request in
                let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
                let countQuery = components?.queryItems?.first(where: { $0.name == "count" })
                #expect(countQuery?.value == "10")
                let termQuery = components?.queryItems?.first(where: { $0.name == "q" })
                #expect(termQuery?.value == "test")
                #expect(components?.scheme == "https")
                #expect(components?.host   == "search.service.gov.uk")
                #expect(components?.path == "/v0_1/search.json")
                #expect(request.httpMethod == "GET")
                let data = request.bodyStreamData
                #expect(data == nil)
                return (.arrangeSuccess, nil, nil)
            }
            let searchRequest = GOVRequest.search(
                term: "test"
            )
            sut.send(
                request: searchRequest,
                completion: { _ in
                    continuation.resume(returning: Void())
                }
            )
        }
    }
}

