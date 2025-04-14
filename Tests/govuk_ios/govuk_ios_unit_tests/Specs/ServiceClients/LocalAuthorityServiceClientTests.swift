import Foundation
import Testing

@testable import govuk_ios

@Suite
struct LocalAuthorityServiceClientTests {

    @Test
    func fetchLocalAuthority_sendsExpectedResults() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(serviceClient: mockAPI)
        let expectedPostcode = "SE129PT"

        sut.fetchLocalAuthority(
            postcode: expectedPostcode) { _ in }

        #expect(mockAPI._receivedSendRequest?.urlPath == "/find-local-council/query.json")
        #expect(mockAPI._receivedSendRequest?.method == .get)
        #expect(mockAPI._receivedSendRequest?.queryParameters?["postcode"] as? String == expectedPostcode)
    }

    @Test
    func fetchLocalAuthority_addressLists_returnsExpectedResult() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(
            serviceClient: mockAPI
        )
        let addresses:[LocalAuthorityAddress] = [
            LocalAuthorityAddress(
                address: "address1",
                slug: "slug1",
                name: "name1"
            ),
            LocalAuthorityAddress(
                address: "address2",
                slug: "slug2",
                name: "name2"
            )
        ]

        let expectedResult = LocalAuthoritiesList(addresses: addresses)
        let stubbedData = try! JSONEncoder().encode(expectedResult)
        mockAPI._stubbedSendResponse = .success(stubbedData)
        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let addressList = localResult as? LocalAuthoritiesList
        #expect(addressList?.addresses.count == 2)
        #expect(addressList?.addresses.first?.name == "name1")
        #expect(addressList?.addresses[1].name == "name2")
        #expect(addressList?.addresses.first?.slug == "slug1")
        #expect(addressList?.addresses[1].name == "name2")
    }

    @Test
    func fetchLocalAuthority_tierOnelocalAuthority_returnsExpectedResult() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(
            serviceClient: mockAPI
        )
        let authority = Authority(
            name: "name1",
            homepageUrl: "homepageUrl",
            tier: "tier1",
            slug: "slug1",
            parent: nil
        )

        let expectedResult = LocalAuthority(localAuthority: authority)
        let stubbedData = try! JSONEncoder().encode(expectedResult)
        mockAPI._stubbedSendResponse = .success(stubbedData)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        let localAuthority = localResult as? LocalAuthority
        #expect(localAuthority?.localAuthority.homepageUrl == "homepageUrl")
        #expect(localAuthority?.localAuthority.name == "name1")
        #expect(localAuthority?.localAuthority.tier == "tier1")
        #expect(localAuthority?.localAuthority.slug == "slug1")
    }

    @Test
    func fetchLocalAuthority_tierTwolocalAuthority_returnsExpectedResult() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(
            serviceClient: mockAPI
        )
        let parentAuthority = Authority(
            name: "parentAuthority",
            homepageUrl: "homepageUrl",
            tier: "parentTier",
            slug: "slug",
            parent: nil
        )
        let authority = Authority(
            name: "name2",
            homepageUrl: "homepageUrl",
            tier: "tier2",
            slug: "slug2",
            parent: parentAuthority
        )
        let expectedResult = LocalAuthority(localAuthority: authority)
        let stubbedData = try! JSONEncoder().encode(expectedResult)
        mockAPI._stubbedSendResponse = .success(stubbedData)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        let localAuthority = localResult as? LocalAuthority
        #expect(localAuthority?.localAuthority.homepageUrl == "homepageUrl")
        #expect(localAuthority?.localAuthority.name == "name2")
        #expect(localAuthority?.localAuthority.tier == "tier2")
        #expect(localAuthority?.localAuthority.slug == "slug2")
        #expect(localAuthority?.localAuthority.parent?.name == "parentAuthority")
    }

    @Test
    func fetchLocalAuthority_apiUnavailable_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(serviceClient: mockAPI)
        mockAPI._stubbedSendResponse = .failure(TestError.fakeNetwork)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        #expect(localResult == nil)
        #expect(result.getError() == .apiUnavailable)
    }

    @Test
    func fetchLocalAuthority_networkUnavailable_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(
            serviceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .failure(
            NSError(domain: "TestError", code: NSURLErrorNotConnectedToInternet)
        )

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        #expect(localResult == nil)
        #expect(result.getError() == .networkUnavailable)
    }

    @Test
    func fetchLocalAuthority_decodingError_returnsExpectedResult() async {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(serviceClient: mockAPI)
        let invalidObject = try! JSONEncoder().encode("Test")
        mockAPI._stubbedSendResponse = .success(invalidObject)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        #expect(localResult == nil)
        #expect(result.getError() == .decodingError)
    }

    @Test
    func fetchLocalAuthority_localErrorMessage_returnsExpectedresult() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(serviceClient: mockAPI)
        let stubbedData = try! JSONEncoder().encode(LocalErrorMessage(message: "errorMessage"))
        mockAPI._stubbedSendResponse = .success(stubbedData)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let errormessage = localResult as? LocalErrorMessage
        #expect(errormessage?.message == "errorMessage")
    }
}
