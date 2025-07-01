import Foundation

 struct LocalAuthorityWidgetViewModel {
    let titleOne: String = String.localAuthority.localized(
        "localAuthorityWidgetViewTitle"
    )
    let titleTwo: String = String.localAuthority.localized(
        "localServicesTitle"
    )
    let description: String = String.localAuthority.localized(
        "localAuthorityWidgetViewDescription"
    )
    let tapAction: () -> Void
}
