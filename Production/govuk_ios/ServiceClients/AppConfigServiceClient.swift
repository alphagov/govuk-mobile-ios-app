import Foundation

typealias FetchAppConfigResult = (Result<AppConfig, AppConfigError>) -> Void

protocol AppConfigServiceClientInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigResult)
}

struct AppConfigServiceClient: AppConfigServiceClientInterface {
    private let serviceClient: APIServiceClientInterface
    private let decoder: SignableDecoder

    init(serviceClient: APIServiceClientInterface,
         decoder: SignableDecoder) {
        self.serviceClient = serviceClient
        self.decoder = decoder
    }

    func fetchAppConfig(completion: @escaping FetchAppConfigResult) {
        let fetchRequest = GOVRequest(
            urlPath: "/config/appinfo/ios",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil,
            requiresSignature: true
        )

        serviceClient.send(
            request: fetchRequest,
            completion: { result in
                let mappedResult: Result<AppConfig, AppConfigError>
                switch result {
                case .failure:
                    mappedResult = .failure(.remoteJson)
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
        } catch SigningError.invalidSignature {
            return .failure(.invalidSignature)
        } catch {
            return .failure(.remoteJson)
        }
    }
}
