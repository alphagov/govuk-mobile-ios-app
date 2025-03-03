import Foundation
import CoreData
import Factory
import GOVKit

extension Container {
    public var coreDataModel: Factory<NSManagedObjectModel> {
        Factory(self) {
            let url = Bundle.main.url(
                forResource: "GOV",
                withExtension: "momd"
            )!
            return NSManagedObjectModel(
                contentsOf: url
            )!
        }
        .scope(.singleton)
    }
}
