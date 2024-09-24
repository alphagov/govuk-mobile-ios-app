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
    var appConfigRepository: Factory<AppConfigRepositoryInterface> {
        Factory(self) {
            AppConfigRepository()
        }
    }
}
