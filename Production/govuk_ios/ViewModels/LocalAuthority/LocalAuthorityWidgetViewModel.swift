import Foundation

 struct LocalAuthorityWidgetViewModel {
    let title: String = String.localAuthority.localized(
        "localServicesTitle"
    )

     let editButtonTitle: String = String.localAuthority.localized(
        "localAuthorityEditButtonTitle"
     )
    let description: String = String.localAuthority.localized(
        "localAuthorityWidgetViewDescription"
    )
    let tapAction: () -> Void
    let editAction: () -> Void
}
