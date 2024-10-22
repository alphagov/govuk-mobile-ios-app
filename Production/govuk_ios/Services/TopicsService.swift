import Foundation

protocol TopicsServiceInterface {
    func downloadTopicsList(completion: @escaping FetchTopicsListResult)
    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult)
    func fetchAllTopics() -> [Topic]
    func fetchFavoriteTopics() -> [Topic]
    func updateFavoriteTopics()
}

extension TopicsServiceInterface {
    static var stepByStepSubTopic: DisplayableTopic {
        TopicDetailResponse.Subtopic(
            ref: "stepByStepRef",
            title: String.topics.localized("topicDetailStepByStepHeader")
        )
    }
}

class TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface
    private let topicsRepository: TopicsRepositoryInterface
    private var currentTopicDetails: TopicDetailResponse?

    init(topicsServiceClient: TopicsServiceClientInterface,
         topicsRepository: TopicsRepositoryInterface) {
        self.topicsServiceClient = topicsServiceClient
        self.topicsRepository = topicsRepository
    }

    func downloadTopicsList(completion: @escaping FetchTopicsListResult) {
        topicsServiceClient.fetchTopicsList(
            completion: { [weak self] result in
                switch result {
                case .success(let topics):
                    self?.topicsRepository.saveTopicsList(topics)
                    completion(.success(topics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult) {
        if topicRef == Self.stepByStepSubTopic.ref {
            if let response = stepByStepDetails() {
                completion(.success(response))
            } else {
                completion(.failure(.missingData))
            }
        } else {
            downloadTopicDetails(
                topicRef: topicRef,
                completion: completion
            )
        }
    }

    private func downloadTopicDetails(topicRef: String,
                                      completion: @escaping FetchTopicDetailsResult) {
        topicsServiceClient.fetchTopicDetails(
            topicRef: topicRef,
            completion: { [weak self] result in
                switch result {
                case .success(let topicDetail):
                    self?.currentTopicDetails = topicDetail
                    completion(.success(topicDetail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func fetchAllTopics() -> [Topic] {
        topicsRepository.fetchAllTopics()
    }

    func fetchFavoriteTopics() -> [Topic] {
        topicsRepository.fetchFavoriteTopics()
    }

    func updateFavoriteTopics() {
        topicsRepository.saveChanges()
    }

    private func stepByStepDetails() -> TopicDetailResponse? {
        guard let currentDetails = currentTopicDetails else { return nil }
        let stepContent = currentDetails.content.filter { $0.isStepByStep }
        let stepDetails = TopicDetailResponse(
            content: stepContent,
            ref: currentDetails.ref,
            subtopics: [],
            title: String.topics.localized("topicDetailStepByStepHeader")
        )
        return stepDetails
    }
}
