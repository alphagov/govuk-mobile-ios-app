import Foundation

typealias FetchAppConfigResult = (Result<AppConfig, AppConfigError>) -> Void

protocol AppConfigServiceClientInterface {
    func fetchAppConfig(completion: @escaping FetchAppConfigResult)
}

class AppConfigServiceClient: AppConfigServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchAppConfig(completion: @escaping FetchAppConfigResult) {
        let fetchRequest = GOVRequest(
            urlPath: "/appinfo/ios",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )

        serviceClient.send(
            request: fetchRequest,
            completion: { result in
                switch result {
                case .failure:
                    completion(.failure(.remoteJsonError))
                case .success:
                    do {
                        guard let resultData = try? result.get() else {
                            return completion(.failure(.remoteJsonError))
                        }
                        let decodedObject = try SignableDecoder().decode(AppConfig.self,
                                                                         from: resultData)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(.remoteJsonError))
                    }
                }
            }
        )
    }
}
