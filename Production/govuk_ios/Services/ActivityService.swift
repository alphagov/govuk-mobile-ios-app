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
        repository.create(params: params)
    }
}

struct ActivityItemCreateParams {
   var id: String
   var title: String
   var date: Date
   var url: String
}

extension ActivityItemCreateParams {
    init(searchItem: SearchItem) {
        self.id = searchItem.link
        self.title = searchItem.title
        self.date = Date()
        self.url = searchItem.link
    }
}
