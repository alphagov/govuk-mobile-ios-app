import Foundation
import GOVKit

extension DeviceInformationProviderInterface {
    var deviceDescription: String {
        "Apple \(model) \(systemVersion)"
    }

    func helpAndFeedbackURL(versionProvider: AppVersionProvider) -> URL {
        let appVersion = versionProvider.fullBuildNumber ?? "-"

        var feedbackUrl = URLComponents(
            url: Constants.API.helpAndFeedbackUrl,
            resolvingAgainstBaseURL: true
        )
        feedbackUrl?.queryItems = [
            .init(name: "app_version", value: appVersion),
            .init(name: "phone", value: deviceDescription)
        ]

        return feedbackUrl?.url ?? Constants.API.helpAndFeedbackUrl
    }
}
