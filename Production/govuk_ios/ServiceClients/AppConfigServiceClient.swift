import Foundation
import GOVKit

import FirebaseCrashlytics

typealias FetchAppConfigCompletion = (sending FetchAppConfigResult) -> Void
typealias FetchAppConfigResult = Result<AppConfig, AppConfigError>

protocol AppConfigServiceClientInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion)
}

struct AppConfigServiceClient: AppConfigServiceClientInterface {
    private let serviceClient: APIServiceClientInterface
    private let decoder = JSONDecoder()

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchAppConfig(completion: @escaping FetchAppConfigCompletion) {
        serviceClient.send(
            request: .config,
            completion: { result in
                let mappedResult = parseConfigResult(result)
                completion(mappedResult)
            }
        )
    }

    private func parseConfigResult(_ result: NetworkResult<Data>) -> FetchAppConfigResult {
        result.mapError { error in
            let nsError = (error as NSError)

            guard nsError.code != NSURLErrorNotConnectedToInternet
            else { return AppConfigError.networkUnavailable }

            if error is SigningError {
                return AppConfigError.invalidSignature
            } else {
                return AppConfigError.remoteJson
            }
        }.flatMap {
            self.decode(data: $0)
        }
    }

    private func decode(data: Data) -> Result<AppConfig, AppConfigError> {
        do {
            let result = try self.decoder.decode(
                AppConfig.self,
                from: data
            )
            return .success(result)
        } catch {
            return .failure(.remoteJson)
        }
    }
}
