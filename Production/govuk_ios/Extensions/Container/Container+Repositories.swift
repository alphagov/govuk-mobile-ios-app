import Foundation
import Factory
import RecentActivity

extension Container {
    var topicsRepository: Factory<TopicsRepositoryInterface> {
        Factory(self) {
            TopicsRepository(coreData: self.coreDataRepository())
        }
    }

    var searchHistoryRepository: Factory<SearchHistoryRepositoryInterface> {
        Factory(self) {
            SearchHistoryRepository(coreData: self.coreDataRepository())
        }
    }
}
