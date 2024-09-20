import Foundation

class AppConfigProvider: AppConfigProviderInterface {
    private let apiService: APIServiceClient

    init(apiService: APIServiceClient) {
        self.apiService = apiService
    }

    func fetchLocalAppConfig(filename: String,
                             completion: @escaping FetchAppConfigResult) {
        let config = loadJSON(filename: filename, bundle: .main)
        completion(config)
    }

    private func loadJSON(filename: String,
                          bundle: Bundle) -> Result<AppConfig, AppConfigError> {
        let resourceURL = bundle.url(
            forResource: filename,
            withExtension: "json"
        )
        guard let resourceURL = resourceURL else {
            return .failure(.loadJsonError)
        }
        do {
            let data = try Data(contentsOf: resourceURL)
            let decodedObject = try JSONDecoder().decode(AppConfig.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.loadJsonError)
        }
    }

    func fetchRemoteAppConfig(completion: @escaping FetchAppConfigResult) {
        apiService.send(
            request: getRequest(),
            completion: { result in
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
        )
    }

    private func getRequest() -> GOVRequest {
        GOVRequest(
            urlPath: Constants.API.appConfigPath,
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )
    }
}
