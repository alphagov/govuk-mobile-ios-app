import Foundation

typealias FetchAppConfigResult = (Result<AppConfig, AppConfigError>) -> Void

protocol AppConfigServiceClientInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigResult)
}

struct AppConfigServiceClient: AppConfigServiceClientInterface {
    private let serviceClient: APIServiceClientInterface
    private let decoder = JSONDecoder()

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchAppConfig(completion: @escaping FetchAppConfigResult) {
        let fetchRequest = GOVRequest(
            urlPath: "/config/appinfo/ios",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
        )

        serviceClient.send(
            request: fetchRequest,
            completion: { result in
                let mappedResult: Result<AppConfig, AppConfigError>
                switch result {
                case .failure(let error):
                    if error is SigningError {
                        mappedResult = .failure(.invalidSignature)
                    } else {
                        mappedResult = .failure(.remoteJson)
                    }
                case .success(let data):
                    mappedResult = self.decode(data: data)
                }
                completion(mappedResult)
            }
        )
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
