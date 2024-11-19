import Foundation

typealias FetchTopicsListCompletion = (sending FetchTopicsListResult) -> Void
typealias FetchTopicsListResult = Result<[TopicResponseItem], TopicsServiceError>

typealias FetchTopicDetailsCompletion = (FetchTopicDetailsResult) -> Void
typealias FetchTopicDetailsResult = Result<TopicDetailResponse, TopicsServiceError>

protocol TopicsServiceClientInterface {
    func fetchList(completion: @escaping FetchTopicsListCompletion)
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion)
}

enum TopicsServiceError: Error {
    case apiUnavailable
    case decodingError
}

struct TopicsServiceClient: TopicsServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func fetchList(completion: @escaping FetchTopicsListCompletion) {
        let topicsRequest = GOVRequest(
            urlPath: "/static/topics/list",
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
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

    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion) {
        let topicsRequest = GOVRequest(
            urlPath: "/static/topics/" + ref,
            method: .get,
            bodyParameters: nil,
            queryParameters: nil,
            additionalHeaders: nil,
            signingKey: Constants.SigningKey.govUK
        )

        serviceClient.send(
            request: topicsRequest,
            completion: { result in
                switch result {
                case .success(let data):
                    do {
                        let topics = try JSONDecoder().decode(TopicDetailResponse.self, from: data)
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
