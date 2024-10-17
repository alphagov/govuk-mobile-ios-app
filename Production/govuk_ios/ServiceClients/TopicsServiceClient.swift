import Foundation

typealias FetchTopicsListResult = (Result<[TopicResponseItem], TopicsServiceError>) -> Void
typealias FetchTopicDetailsResult = (Result<TopicDetailResponse, TopicsServiceError>) -> Void

protocol TopicsServiceClientInterface {
    func fetchTopicsList(completion: @escaping FetchTopicsListResult)
    func fetchTopicDetails(for topicRef: String, completion: @escaping FetchTopicDetailsResult)
}

enum TopicsServiceError: Error {
    case apiUnavailable
    case decodingError
    case missingData
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

    func fetchTopicDetails(for topicRef: String, completion: @escaping FetchTopicDetailsResult) {
        let topicsRequest = GOVRequest(
            urlPath: "/static/topics/" + topicRef,
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
