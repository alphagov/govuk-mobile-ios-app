import Foundation
import GOVKit

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
    case networkUnavailable
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
                completion(handleResponse(result))
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
                completion(handleResponse(result))
            }
        )
    }

    private func handleResponse<T: Decodable>(
        _ result: NetworkResult<Data>
    ) -> Result<T, TopicsServiceError> {
        let mappedResult = result.mapError { error in
            let nsError = error as NSError
            if nsError.code == NSURLErrorNotConnectedToInternet {
                return TopicsServiceError.networkUnavailable
            } else {
                return TopicsServiceError.apiUnavailable
            }
        }.flatMap {
            do {
                let topics = try JSONDecoder().decode(T.self, from: $0)
                return .success(topics)
            } catch {
                return .failure(TopicsServiceError.decodingError)
            }
        }
        return mappedResult
    }
}
