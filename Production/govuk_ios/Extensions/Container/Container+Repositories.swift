import Foundation
import Factory
import RecentActivity

extension Container {
    var activityRepository: Factory<ActivityRepositoryInterface> {
        Factory(self) {
            ActivityRepository(
                coreData: self.coreDataRepository()
            )
        }
    }

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
