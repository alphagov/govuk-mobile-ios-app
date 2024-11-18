import Foundation

struct AppLaunchResponse {
    let configResult: FetchAppConfigResult
    let topicResult: FetchTopicsListResult

    var isAppAvailable: Bool {
        guard let result = try? configResult.get()
        else { return false }
        return result.config.available
    }

    var hasErrors: Bool {
        let errors: [Error?] = [
            configResult.getError(),
            topicResult.getError()
        ]
        return errors
            .compactMap { $0 }
            .isEmpty == false
    }

    var isAppForcedUpdate: Bool {
        guard case .failure(.invalidSignature) = configResult
        else { return false }
        return true
    }
}
