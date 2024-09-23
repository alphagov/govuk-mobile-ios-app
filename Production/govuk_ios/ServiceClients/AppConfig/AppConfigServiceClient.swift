import Foundation

class AppConfigServiceClient: AppConfigServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchAppConfig(completion: @escaping FetchAppConfigResult) {
        let fetchRequest = GOVRequest(
            urlPath: Constants.API.appConfigPath,
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )

        serviceClient.send(
            request: fetchRequest) { result in
                switch result {
                case .failure:
                    completion(.failure(.remoteJsonError))
                case .success:
                    do {
                        guard let resultData = try? result.get() else {
                            return completion(.failure(.remoteJsonError))
                        }
                        let decodedObject = try JSONDecoder().decode(AppConfig.self,
                                                                     from: resultData)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(.remoteJsonError))
                    }
                }
            }
    }
}
