import Foundation

 struct LocalAuthorityWidgetViewModel {
    let title: String = String.localAuthority.localized(
        "localServicesTitle"
    )
    let description: String = String.localAuthority.localized(
        "localAuthorityWidgetViewDescription"
    )
    let tapAction: () -> Void
}
