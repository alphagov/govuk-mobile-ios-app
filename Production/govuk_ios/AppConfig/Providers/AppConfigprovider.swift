import Foundation

class AppConfigProvider: AppConfigProviderInterface {
    typealias FetchResult = (Result<AppConfig, AppConfigError>) -> Void

    private let apiService: APIServiceClient

    private lazy var request = GOVRequest(
        urlPath: Constants.API.appConfigPath,
        method: .get,
        bodyParameters: nil,
        queryParameters: nil,
        additionalHeaders: nil
    )

    init(apiService: APIServiceClient) {
        self.apiService = apiService
    }

    func fetchLocalAppConfig(filename: String,
                             completion: @escaping FetchResult) {
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

    func fetchRemoteAppConfig(completion: @escaping FetchResult) {
        apiService.send(
            request: request,
            completion: { result in
                do {
                    guard let resultData = try? result.get() else {
                        return completion(.failure(.remoteJsonError))
                    }
                    let decodedObject = try JSONDecoder().decode(AppConfig.self, from: resultData)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.remoteJsonError))
                }
            }
        )
    }
}
