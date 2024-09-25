import Foundation
import Factory

extension Container {
    var activityRepository: Factory<ActivityRepositoryInterface> {
        Factory(self) {
            let repository  =
            ActivityRepository(
                coreData: self.coreDataRepository()
            )
            repository.saveTest()
            return repository
        }
    }
    var appConfigRepository: Factory<AppConfigRepositoryInterface> {
        Factory(self) {
            AppConfigRepository()
        }
    }
}
