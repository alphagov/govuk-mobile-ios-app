import Foundation
import UIComponents
import GOVKit
import Combine

class LocalAuthorityViewModel: ObservableObject {
    private let service: LocalAuthorityServiceInterface
    @Published var localAuthority: LocalAuthority?
    @Published var localAuthorityAddressList: LocalAuthoritiesList?
    @Published var localAuthorityErrorMessage: LocalErrorMessage?
    private let explainerPrimaryButtonTitle: String = String.localAuthority.localized(
        "localAuthorityExplainerViewPrimaryButtonTitle"
    )
    @Published var showPostcodeEntryView: Bool = false
    @Published var postCode: String = ""
    @Published var shouldShowErrorMessage: Bool = false
    private let analyticsService: AnalyticsServiceInterface
    private var cancellables = Set<AnyCancellable>()
    let navigateToPosteCodeEntry: () -> Void
    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )
    let explainerViewTitle: String = String.localAuthority.localized(
        "localAuthorityExplainerViewTitle"
    )
    let explainerViewDescription: String = String.localAuthority.localized(
        "localAuthorityExplainerViewDesciption"
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
    let navigationTitle: String = String.localAuthority.localized(
        "localAuthorityNavigationTitle"
    )
    let widgetViewTitleOne: String = String.localAuthority.localized(
        "localAuthorityWidgetViewTitle"
    )
    let widgetViewTitleTwo: String = String.localAuthority.localized(
        "localAuthorityWidgetViewTitleTwo"
    )
    let widgetViewDescription: String = String.localAuthority.localized(
        "localAuthorityWidgetViewDescription"
    )

    init(service: LocalAuthorityServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         navigateToPosteCodeEntry: @escaping () -> Void) {
        self.service = service
        self.analyticsService = analyticsService
        self.navigateToPosteCodeEntry = navigateToPosteCodeEntry
        addTextFieldSubscribers()
    }

    private func addTextFieldSubscribers() {
        $postCode
            .debounce(
                for: .seconds(0.5),
                scheduler: DispatchQueue.main
            )
            .sink { [weak self] postcode in
                self?.postCode = postcode
            }.store(in: &cancellables)
    }

//    func trackWidgetTap() {
//        dismissAction()
//    }

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

    var explainerViewPrimaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: explainerPrimaryButtonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                let buttonTitle = self.explainerPrimaryButtonTitle
                self.trackNavigationEvent(buttonTitle)
                navigateToPosteCodeEntry()
            }
        )
    }

    var postcodeEntryViewPrimaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: postcodeEntryViewPrimaryButtonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                let postcode = self.postCode
                let buttonTitle = self.postcodeEntryViewPrimaryButtonTitle
                self.trackNavigationEvent(buttonTitle)
                self.fetchLocalAuthority(postCode: postcode)
            }
        )
    }
    // print statements have been left in for post amigos purposes
    func fetchLocalAuthority(postCode: String) {
        service.fetchLocalAuthority(postcode: postCode) { [weak self] results
            in
            switch results {
            case .success(let response as LocalAuthority):
                self?.localAuthority = response
                print(response.localAuthority.name)
            case .success(let response as LocalAuthoritiesList):
                self?.localAuthorityAddressList = response
                print(response.addresses)
            case .success(let response as LocalErrorMessage):
                self?.localAuthorityErrorMessage = response
                print(response.message)
            case .failure(let error):
                self?.shouldShowErrorMessage.toggle()
            default:
                self?.shouldShowErrorMessage.toggle()
            }
        }
    }
}
