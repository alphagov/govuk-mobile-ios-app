import Foundation
import FactoryKit

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

    var localAuthorityRepository: Factory<LocalAuthorityRepositoryInterface> {
        Factory(self) {
            LocalAuthorityRepository(coreData: self.coreDataRepository())
        }
    }


    var searchHistoryRepository: Factory<SearchHistoryRepositoryInterface> {
        Factory(self) {
            SearchHistoryRepository(coreData: self.coreDataRepository())
        }
    }

    var chatRepository: Factory<ChatRepositoryInterface> {
        Factory(self) {
            ChatRepository(coreData: self.coreDataRepository())
        }
    }
}
