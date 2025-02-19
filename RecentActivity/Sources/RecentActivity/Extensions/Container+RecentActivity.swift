import Foundation
import Factory
import GOVKit

extension Container {
    public var activityRepository: Factory<ActivityRepositoryInterface> {
        Factory(self) {
            ActivityRepository(
                coreData: self.coreDataRepository()
            )
        }
    }
}
