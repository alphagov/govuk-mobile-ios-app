import Foundation
import Testing

@testable import govuk_ios

@Suite
struct LocalAuthorityServiceTests {

    @Test
    func fetchLocalAuthority_callsServiceClient() async throws {
        let mockServiceClient = MockLocalServiceClient()
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let expectedPostcode = "SW1"

        sut.fetchLocalAuthority(
            postcode: expectedPostcode) { _ in }
        #expect(mockServiceClient._stubbedPostcode == expectedPostcode)
    }

    @Test
    func fetchSavedLocalAuthority_fetchesFromRepository() async throws {
        let mockServiceClient = MockLocalServiceClient()
        let mockRepository = MockLocalAuthorityRepository()

        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        _ = sut.fetchSavedLocalAuthority()
        #expect(mockRepository._didFetchLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_addressLists_returnsExpectedResult() async throws {
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
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .success(expectedResult)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )

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
        #expect(addressList?.addresses.last?.name == "name2")
        #expect(addressList?.addresses.first?.slug == "slug1")
        #expect(addressList?.addresses.last?.name == "name2")
        #expect(!mockRepository._didSaveLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_tierOnelocalAuthority_returnsExpectedResult() async throws {
        let authority = Authority(
            name: "name1",
            homepageUrl: "homepageUrl",
            tier: "tier1",
            slug: "slug1",
            parent: nil
        )
        let expectedResult = LocalAuthority(localAuthority: authority)
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .success(expectedResult)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let localAuthority = localResult as? LocalAuthority
        #expect(localAuthority?.localAuthority.homepageUrl == "homepageUrl")
        #expect(localAuthority?.localAuthority.name == "name1")
        #expect(localAuthority?.localAuthority.tier == "tier1")
        #expect(localAuthority?.localAuthority.slug == "slug1")
        #expect(mockRepository._didSaveLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_tierTwolocalAuthority_returnsExpectedResult() async throws {
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
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .success(expectedResult)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
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
        #expect(mockRepository._didSaveLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_apiUnavailable_returnsExpectedResult() async throws {
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .failure(.apiUnavailable)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        #expect(localResult == nil)
        #expect(result.getError() == .apiUnavailable)
        #expect(!mockRepository._didSaveLocalAuthority)
    }


    @Test
    func fetchLocalAuthority_decodingError_returnsExpectedResult() async throws {
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .failure(.decodingError)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        #expect(localResult == nil)
        #expect(result.getError() == .decodingError)
        #expect(!mockRepository._didSaveLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_networkUnavailable_returnsExpectedResult() async throws {
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .failure(.networkUnavailable)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        #expect(localResult == nil)
        #expect(result.getError() == .networkUnavailable)
        #expect(!mockRepository._didSaveLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_localErrorMessage_returnsExpectedResult() async throws {
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalPostcodeResult = .success(LocalErrorMessage(message: "errorMessage"))

        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                postcode: "test") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let errorMessage = localResult as? LocalErrorMessage
        #expect(errorMessage?.message == "errorMessage")
        #expect(!mockRepository._didSaveLocalAuthority)
    }
}
