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

    @Test
    func revokeTokenAPIClient_createsExpectedRequest() async throws {
        Container.shared.reset()
        Container.shared.urlSession.register { URLSession.mock }
        Container.shared.appEnvironmentService.register {
            MockAppEnvironmentService()
        }
        let sut = Container.shared.revokeTokenAPIClient()
        return await withCheckedContinuation { continuation in
            MockURLProtocol.requestHandlers["https://www.govuk-auth.com/oauth2/revoke"] = { request in
                let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
                #expect(components?.scheme == "https")
                #expect(components?.host   == "www.govuk-auth.com")
                #expect(components?.path == "/oauth2/revoke")
                #expect(request.httpMethod == "POST")
                if let data = request.bodyStreamData {
                    let query = String(data: data, encoding: .utf8)
                    #expect(
                        (query == "token=token&client_id=clientId") ||
                        (query == "client_id=clientId&token=token")
                    )
                } else {
                    Issue.record("Expected request body")
                }
                return (.arrangeSuccess, nil, nil)
            }
            let request = GOVRequest.revoke("token", clientId: "clientId")

            sut.send(
                request: request,
                completion: { _ in
                    continuation.resume(returning: Void())
                }
            )
        }
    }

    @Test
    func chatAPIClient_createsExpectedRequest() async throws {
        let mockAppEnvironment = MockAppEnvironmentService()
        Container.shared.reset()
        Container.shared.urlSession.register { URLSession.mock }
        Container.shared.appEnvironmentService.register {
            mockAppEnvironment
        }
        let sut = Container.shared.chatAPIClient()

        let responseData = await withCheckedContinuation { continuation in
            var returnData: Data? = nil
            MockURLProtocol.requestHandlers["https://www.govuk-chat.com/conversation/"] = { request in
                #expect(request.httpMethod == "POST")
                #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json")
                #expect(request.allHTTPHeaderFields?["Authorization"] == "Bearer \(mockAppEnvironment.chatAuthToken)")
                returnData = request.bodyStreamData
                return (.arrangeSuccess, nil, nil)
            }

            let request = GOVRequest.askQuestion("What is your quest?")

            sut.send(
                request: request,
                completion: { result in
                    continuation.resume(returning: returnData)
                }
            )
        }
        let data = try #require(responseData)
        let query = String(data: data, encoding: .utf8)
        #expect(query == "{\n  \"user_question\" : \"What is your quest?\"\n}")
    }
}

