import Foundation
import GOVKit

extension DeviceInformationProviderInterface {
    func helpAndFeedbackURL(versionProvider: AppVersionProvider) -> URL {
        helpUrlComponents(
            url: Constants.API.helpAndFeedbackUrl,
            versionProvider: versionProvider,
        )?.url ??
        Constants.API.helpAndFeedbackUrl
    }

    func reportProblem(
        versionProvider: AppVersionProvider,
        error: Error?,
    ) -> URL {
        var whatHappened: String?
        if let error = error {
            whatHappened = String(describing: error)
        }
        return reportProblem(
            versionProvider: versionProvider,
            whatHappened: whatHappened,
        )
    }

    func reportProblem(
        versionProvider: AppVersionProvider,
        whatHappened: String?,
    ) -> URL {
        let url = Constants.API.reportProblemUrl
        var components = helpUrlComponents(
            url: url,
            versionProvider: versionProvider
        )
        if let whatHappened = whatHappened,
           !whatHappened.isEmpty {
            components?.queryItems?.append(
                .init(name: "what_happened", value: whatHappened)
            )
        }
        return components?.url ?? url
    }

    private func helpUrlComponents(
        url: URL,
        versionProvider: AppVersionProvider,
    ) -> URLComponents? {
        let appVersion = versionProvider.fullBuildNumber ?? "-"

        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )
        let queryItems = [
            URLQueryItem(name: "app_version", value: appVersion),
            URLQueryItem(name: "phone", value: deviceDescription),
        ]
        components?.queryItems = queryItems.compactMap { $0.value != nil ? $0 : nil }
        return components
    }

    private var deviceDescription: String {
        "Apple \(model) \(systemVersion)"
    }
}
