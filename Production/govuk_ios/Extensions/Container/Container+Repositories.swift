import Foundation
import Factory

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
}
