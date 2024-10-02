import Foundation

protocol ActivityServiceInterface {
    func save(searchItem: SearchItem)
}

struct ActivityService: ActivityServiceInterface {
    private let repository: ActivityRepositoryInterface

    init(repository: ActivityRepositoryInterface) {
        self.repository = repository
    }

    func save(searchItem: SearchItem) {
        let params = ActivityItemCreateParams(
            searchItem: searchItem
        )
        repository.save(params: params)
    }
}
