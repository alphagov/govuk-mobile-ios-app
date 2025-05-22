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
        let expectedResult = LocalAuthorityResponse(localAuthorityAddresses: addresses)
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
        let addressList = localResult?.localAuthorityAddresses
        #expect(addressList?.count == 2)
        #expect(addressList?.first?.name == "name1")
        #expect(addressList?.last?.name == "name2")
        #expect(addressList?.first?.slug == "slug1")
        #expect(addressList?.last?.name == "name2")
        #expect(!mockRepository._didSaveLocalAuthority)
    }

    @Test
    func fetchLocalAuthority_slug_returnsExpectedResult() async throws {
        let authority = Authority(
            name: "name1",
            homepageUrl: "homepageUrl",
            tier: "tier1",
            slug: "slug1",
            parent: nil
        )

        let expectedResult = LocalAuthorityResponse(localAuthority: authority)
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalSlugResult = .success(expectedResult)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthority(
                slug: "slug1") { result in
                    continuation.resume(returning: result)
                }
        }
        let localResult = try? result.get()
        let authorityResult = localResult?.localAuthority
        #expect(authorityResult?.name == "name1")
        #expect(authorityResult?.homepageUrl == "homepageUrl")
        #expect(authorityResult?.tier == "tier1")
        #expect(authorityResult?.slug == "slug1")
    }

    @Test
    func fetchLocalAuthorities_returnsExpectedResult() async throws {
        let authorityOne = Authority(
            name: "name1",
            homepageUrl: "homepageUrl",
            tier: "tier1",
            slug: "slug1",
            parent: nil
        )
        let authorityTwo = Authority(
            name: "name2",
            homepageUrl: "homepageUrl",
            tier: "tier2",
            slug: "slug2",
            parent: nil
        )

        let expectedResult = [authorityOne, authorityTwo]
        let mockServiceClient = MockLocalServiceClient()
        mockServiceClient._stubbedLocalAuthoritiesResult = .success(expectedResult)
        let mockRepository = MockLocalAuthorityRepository()
        let sut = LocalAuthorityService(
            serviceClient: mockServiceClient,
            repository: mockRepository
        )

        let result = await withCheckedContinuation { continuation in
            sut.fetchLocalAuthorities(
                slugs: ["slug1", "slug2"]) { result in
                    continuation.resume(returning: result)
                }
        }
        let authorities = try? result.get()
        #expect(authorities?.count == 2)
        #expect(authorities?.first?.name == "name1")
        #expect(authorities?.last?.name == "name2")
        #expect(authorities?.first?.slug == "slug1")
        #expect(authorities?.last?.slug == "slug2")
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
        let expectedResult = LocalAuthorityResponse(localAuthority: authority)
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
        let localAuthority = localResult?.localAuthority
        #expect(localAuthority?.homepageUrl == "homepageUrl")
        #expect(localAuthority?.name == "name1")
        #expect(localAuthority?.tier == "tier1")
        #expect(localAuthority?.slug == "slug1")
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
        let expectedResult = LocalAuthorityResponse(localAuthority: authority)
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
        let localAuthority = localResult?.localAuthority
        #expect(localAuthority?.homepageUrl == "homepageUrl")
        #expect(localAuthority?.name == "name2")
        #expect(localAuthority?.tier == "tier2")
        #expect(localAuthority?.slug == "slug2")
        #expect(localAuthority?.parent?.name == "parentAuthority")
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
        let response = LocalAuthorityResponse(localAuthorityErrorMessage: "errorMessage")
        mockServiceClient._stubbedLocalPostcodeResult = .success(response)

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
        let errorMessage = localResult?.localAuthorityErrorMessage
        #expect(errorMessage == "errorMessage")
        #expect(!mockRepository._didSaveLocalAuthority)
    }
}
