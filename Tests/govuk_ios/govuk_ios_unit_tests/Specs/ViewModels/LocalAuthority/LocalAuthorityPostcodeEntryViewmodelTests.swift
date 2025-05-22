import Foundation
import Testing
import Combine

@testable import govuk_ios

@Suite
struct LocalAuthorityPostcodeEntryViewmodelTests {
    
    @Test
    func fetchLocalAuthority_addressList_returnsExpectedResults() async throws {
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

        let authorities = [
            Authority(
                name: "name1",
                homepageUrl: "https://authority1",
                tier: "tier1",
                slug: "slug1"
            ),
            Authority(
                name: "name2",
                homepageUrl: "https://authority2",
                tier: "tier2",
                slug: "slug2"
            )
        ]

        let expectedAddressResponse = LocalAuthorityResponse(localAuthorityAddresses: addresses)
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalPostcodeResult = .success(expectedAddressResponse)
        mockService._stubbedLocalAuthoritiesResult = .success(authorities)

        var expectedAddresses = [LocalAuthorityAddress]()
        _ = await withCheckedContinuation { continuation in
            let sut = LocalAuthorityPostcodeEntryViewModel(
                service: mockService,
                analyticsService: MockAnalyticsService(),
                resolveAmbiguityAction: { authorities, postCode in
                    expectedAddresses = authorities.addresses
                    continuation.resume()
                },
                dismissAction: {}
            )
            sut.postCode = "test"
            sut.primaryButtonViewModel.action()
        }
        #expect(expectedAddresses.count == addresses.count)
        #expect(expectedAddresses.first?.address == addresses.first?.address)
    }

    @Test
    func returnErrorMessage_emptyString_returnsExpectedResult() async throws {
        let sut = LocalAuthorityPostcodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: MockAnalyticsService(),
            resolveAmbiguityAction: { _, _ in },
            dismissAction: {}
        )
        sut.primaryButtonViewModel.action()
        #expect(sut.error?.errorMessage == "Enter your postcode")
    }

    @Test
    func returnErrorMessage_invalidPostcode_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let expectedResult = LocalAuthorityResponse(
            localAuthorityErrorMessage: "Invalid postcode"
        )
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalPostcodeResult = .success(expectedResult)

        let sut = LocalAuthorityPostcodeEntryViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            resolveAmbiguityAction: { _, _ in },
            dismissAction: {}
        )
        let result = await withCheckedContinuation { continuation in
            sut.$error
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { errorMessage in
                    continuation.resume(returning: errorMessage)
                }
                .store(in: &cancellables)
            sut.postCode = "test"
            sut.primaryButtonViewModel.action()
        }
        #expect(result?.errorMessage == "Enter a postcode in the correct format")
    }


    @Test
    func returnErrorMessage_postcodeNotFound_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let expectedResult = LocalAuthorityResponse(
            localAuthorityErrorMessage: "Postcode not found"
        )
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalPostcodeResult = .success(expectedResult)

        let sut = LocalAuthorityPostcodeEntryViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            resolveAmbiguityAction: { _, _ in },
            dismissAction: {}
        )
        let result = await withCheckedContinuation { continuation in
            sut.$error
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { errorMessage in
                    continuation.resume(returning: errorMessage)
                }
                .store(in: &cancellables)
            sut.postCode = "test"
            sut.primaryButtonViewModel.action()
        }
        #expect(result?.errorMessage == "We could not find a council for this postcode. Check the postcode and try again.")
    }

    @Test
    func primaryButtonViewModel_action_trackNavigationEvent() async throws {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthorityPostcodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: mockAnalyticsService,
            resolveAmbiguityAction: { _, _ in },
            dismissAction: {}
        )
        sut.postCode = "SW1A 0AA"
        sut.primaryButtonViewModel.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == "Confirm postcode")
    }

}
