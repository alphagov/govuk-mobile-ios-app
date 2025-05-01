import Foundation
import UIComponents
import GOVKit

class LocalAuthorityPostecodeEntryViewModel: ObservableObject {
    private let service: LocalAuthorityServiceInterface
    @Published var localAuthority: LocalAuthority?
    @Published var localAuthorityAddressList: LocalAuthoritiesList?
    @Published var localAuthorityErrorMessage: LocalErrorMessage?
    @Published var postCode: String = ""
    @Published var shouldShowErrorMessage: Bool = false
    private let analyticsService: AnalyticsServiceInterface
    let dismissAction: () -> Void
    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )
    let postcodeEntryViewDescription: String = String.localAuthority.localized(
        "localAuthrorityExplainerViewDescription"
    )
    let postcodeEntryViewTitle: String =  String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewTitle"
    )
    let postcodeEntryViewExampleText: String = String.localAuthority.localized(
        "localAthorityPostcodeEntryViewExampleText"
    )
    let postcodeEntryViewDescriptionTitle: String = String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewDescriptionTitle"
    )
    let postcodeEntryViewDescriptionBody: String = String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewDescriptionBody"
    )
    private let postcodeEntryViewPrimaryButtonTitle: String = String.localAuthority.localized(
        "localAuthoritypostcodeEntryPrimaryButtonTitle"
    )

    init(service: LocalAuthorityServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.service = service
        self.analyticsService = analyticsService
        self.dismissAction = dismissAction
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: true
        )
        analyticsService.track(event: event)
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: postcodeEntryViewPrimaryButtonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                let postcode = self.postCode
                let buttonTitle = self.postcodeEntryViewPrimaryButtonTitle
                self.trackNavigationEvent(buttonTitle)
                self.fetchLocalAuthority(postCode: postcode)
                dismissAction()
            }
        )
    }

    func fetchLocalAuthority(postCode: String) {
        service.fetchLocalAuthority(postcode: postCode) { [weak self] results
            in
            switch results {
            case .success(let response as LocalAuthority):
                self?.localAuthority = response
            case .success(let response as LocalAuthoritiesList):
                self?.localAuthorityAddressList = response
            case .success(let response as LocalErrorMessage):
                self?.localAuthorityErrorMessage = response
            case .failure(let error):
                self?.shouldShowErrorMessage.toggle()
            default:
                break
            }
        }
    }
}
