import Foundation
import CoreData

protocol SearchServiceInterface {
    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void)
    func suggestions(_ term: String,
                     completion: @escaping ([String]) -> Void)
    func save(searchText: String, date: Date)
    func delete(_ item: SearchHistoryItem)
    func clearSearchHistory()
    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem>? { get }
}

class SearchService: SearchServiceInterface {
    private let serviceClient: SearchServiceClientInterface
    private let repository: SearchHistoryRepositoryInterface

    init(serviceClient: SearchServiceClientInterface,
         repository: SearchHistoryRepositoryInterface) {
        self.serviceClient = serviceClient
        self.repository = repository
    }

    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem>? {
        repository.fetchedResultsController
    }

    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        serviceClient.search(
            term: term,
            completion: { result in
                let mappedResult: Result<SearchResult, SearchError> = result.flatMap {
                    $0.results.isEmpty ? .failure(.noResults) : .success($0)
                }

                DispatchQueue.main.async {
                    completion(mappedResult)
                }
            }
        )
    }

    func suggestions(_ term: String,
                     completion: @escaping ([String]) -> Void) {
        serviceClient.suggestions(
            term: term,
            completion: { result in
                let suggestions = (try? result.get().suggestions) ?? []

                DispatchQueue.main.async {
                    completion(suggestions)
                }
            }
        )
    }

    func save(searchText: String, date: Date) {
        repository.save(searchText: searchText, date: date)
    }

    func clearSearchHistory() {
        repository.clearSearchHistory()
    }

    func delete(_ item: SearchHistoryItem) {
        repository.delete(item)
    }
}
