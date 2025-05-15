import Foundation
import Testing
import Combine

@testable import govuk_ios

@Suite
struct LocalAuthorityPostcodeEntryViewmodelTests {
    
    @Test
    func fetchLocalAuthority_addressList_returnsExpectedResults() async throws {
        var cancellables = Set<AnyCancellable>()
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
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)
        let sut = LocalAuthorityPostecodeEntryViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        let result = await withCheckedContinuation { continuation in
            sut.$localAuthorityAddressList
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.postCode = "test"
            sut.primaryButtonViewModel.action()
        }
        #expect(result?.addresses.count == 2)
        #expect(result?.addresses.first?.name == "name1")
        #expect(result?.addresses.last?.name == "name2")
        #expect(result?.addresses.first?.slug == "slug1")
    }

    @Test
    func returnErrorMessage_emptyString_returnsExpectedResult() async throws {
        let sut = LocalAuthorityPostecodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: MockAnalyticsService(),
            dismissAction: {}
        )
        sut.primaryButtonViewModel.action()
        #expect(sut.error?.errorMessage == "Enter your postcode")
    }

    @Test
    func returnErrorMessage_invalidPostcode_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let expectedResult = LocalErrorMessage(message: "Invalid postcode")
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)

        let sut = LocalAuthorityPostecodeEntryViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
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
        let expectedResult = LocalErrorMessage(message: "Postcode not found")
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)

        let sut = LocalAuthorityPostecodeEntryViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
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
        let sut = LocalAuthorityPostecodeEntryViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: mockAnalyticsService,
            dismissAction: {}
        )
        sut.postCode = "SW1A 0AA"
        sut.primaryButtonViewModel.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == "Confirm postcode")
    }

}
