import Foundation
import CoreData
import GOVKit

protocol LocalAuthorityRepositoryInterface {
    func save(_ authority: Authority)
    func fetchLocalAuthority() -> [LocalAuthorityItem]
}

struct LocalAuthorityRepository: LocalAuthorityRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func save(_ authority: Authority) {
        let context = coreData.backgroundContext
        var oldLocalAuthorityItems = [LocalAuthorityItem]()

        context.performAndWait {
            oldLocalAuthorityItems = fetch(context: context)
        }
        oldLocalAuthorityItems.forEach {
            context.delete($0)
        }

        let localAuthorityItem = LocalAuthorityItem(context: context)
        localAuthorityItem.update(with: authority)

        if let parentAuthority = authority.parent {
            let localParent = LocalAuthorityItem(context: context)
            localParent.update(with: parentAuthority)
            localAuthorityItem.parent = localParent
        }

        try? context.save()
    }

    func fetchLocalAuthority() -> [LocalAuthorityItem] {
        fetch(context: coreData.viewContext)
    }

    private func fetch(context: NSManagedObjectContext) -> [LocalAuthorityItem] {
        let fetchRequest = LocalAuthorityItem.fetchRequest()
        return (try? context.fetch(fetchRequest)) ?? []
    }
}
