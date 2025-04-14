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

        mockAPI._stubbedSendResponse = .success(Self.localAuthorityListData)
        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let addressList = localResult as? LocalAuthoritiesList
        #expect(addressList?.addresses.count == 2)
        #expect(addressList?.addresses.first?.name == "Dorset County Council")
        #expect(addressList?.addresses.last?.name == "Bournemouth, Christchurch, and Poole")
        #expect(addressList?.addresses.first?.slug == "dorset")
    }

    @Test
    func fetchLocalAuthority_tierOnelocalAuthority_returnsExpectedResult() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(
            serviceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .success(Self.localAuthorityTierOneData)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        let localAuthority = localResult as? LocalAuthority
        #expect(localAuthority?.localAuthority.homepageUrl == "https://www.towerhamlets.gov.uk")
        #expect(localAuthority?.localAuthority.name == "London Borough of Tower Hamlets")
        #expect(localAuthority?.localAuthority.tier == "unitary")
        #expect(localAuthority?.localAuthority.slug == "tower-hamlets")
    }

    @Test
    func fetchLocalAuthority_tierTwolocalAuthority_returnsExpectedResult() async throws {
        let mockAPI = MockAPIServiceClient()
        let sut = LocalAuthorityServiceClient(
            serviceClient: mockAPI
        )
        mockAPI._stubbedSendResponse = .success(Self.localAuthorityTierTwoData)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(postcode: "test") { result in
                continuation.resume(returning: result)
            }
        }
        let localResult = try? result.get()
        let localAuthority = localResult as? LocalAuthority
        #expect(localAuthority?.localAuthority.homepageUrl == "https://www.derbyshiredales.gov.uk/")
        #expect(localAuthority?.localAuthority.name == "Derbyshire Dales District Council")
        #expect(localAuthority?.localAuthority.tier == "district")
        #expect(localAuthority?.localAuthority.slug == "derbyshire-dales")
        #expect(localAuthority?.localAuthority.parent?.name == "Derbyshire County Council")
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
        mockAPI._stubbedSendResponse = .success(Self.invalidObjectData)

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
        mockAPI._stubbedSendResponse = .success(Self.localAuthorityErrorMessage)

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let errormessage = localResult as? LocalErrorMessage
        #expect(errormessage?.message == "Postcode not found")
    }
}
private extension LocalAuthorityServiceClientTests {

    static let localAuthorityTierOneData =
    """
    {
        "local_authority": {
            "name": "London Borough of Tower Hamlets",
            "homepage_url": "https://www.towerhamlets.gov.uk",
            "tier": "unitary",
            "slug": "tower-hamlets",
            "parent": null
        }
    }
    """.data(using: .utf8)!

    static let localAuthorityListData =
    """
    {
        "addresses": [
            {
                "address": "APPLETREE COTTAGE, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
                "slug": "dorset",
                "name": "Dorset County Council"
            },
            {
                "address": "LONGCROFT BRICK, BARRACK ROAD, FERNDOWN, DORSET, BH22 8UB",
                "slug": "bournemouth-christchurch-poole",
                "name": "Bournemouth, Christchurch, and Poole"
            }
        ]
    }
    """.data(using: .utf8)!

    static let localAuthorityTierTwoData =
    """
    {
        "local_authority": {
            "name": "Derbyshire Dales District Council",
            "homepage_url": "https://www.derbyshiredales.gov.uk/",
            "tier": "district",
            "slug": "derbyshire-dales",
            "parent": {
                "name": "Derbyshire County Council",
                "homepage_url": "https://www.derbyshiredales.gov.uk/",
                "tier": "county",
                "slug": "derbyshire",
                "parent": null
            }
        }
    }
    """.data(using: .utf8)!

    static let localAuthorityErrorMessage =
    """
    {
    "message": "Postcode not found"
    }
    """.data(using: .utf8)!

    static let invalidObjectData =
    """
    {
    "Test"
    }
    """.data(using: .utf8)!
}
