import Foundation

typealias FetchTopicsListResult = (Result<[TopicResponseItem], TopicsListError>) -> Void

protocol TopicsServiceClientInterface {
    func fetchTopicsList(completion: @escaping FetchTopicsListResult)
}

enum TopicsListError: Error {
    case apiUnavailable
    case decodingError
}

struct TopicsServiceClient: TopicsServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchTopicsList(completion: @escaping FetchTopicsListResult) {
        let topicsRequest = GOVRequest(
            urlPath: "/static/topics/list",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil
        )

        serviceClient.send(
            request: topicsRequest,
            completion: { result in
                switch result {
                case .success(let data):
                    do {
                        let topics = try JSONDecoder().decode([TopicResponseItem].self, from: data)
                        completion(.success(topics))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                case .failure:
                    completion(.failure(.apiUnavailable))
                }
            }
        )
    }
}
