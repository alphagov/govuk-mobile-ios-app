import Foundation

protocol ActivityRepositoryInterface {
}

class ActivityRepository: ActivityRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }
}
