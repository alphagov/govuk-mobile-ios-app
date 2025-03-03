import Foundation
import Factory
import GOVKit
import RecentActivity

extension Container {
    public var activityRepository: Factory<ActivityRepositoryInterface> {
        Factory(self) {
            ActivityRepository(
                coreData: CoreDataRepository.govUK
            )
        }
    }

    var topicsRepository: Factory<TopicsRepositoryInterface> {
        Factory(self) {
            TopicsRepository(coreData: CoreDataRepository.govUK)
        }
    }

    var searchHistoryRepository: Factory<SearchHistoryRepositoryInterface> {
        Factory(self) {
            SearchHistoryRepository(coreData: CoreDataRepository.govUK)
        }
    }
}
