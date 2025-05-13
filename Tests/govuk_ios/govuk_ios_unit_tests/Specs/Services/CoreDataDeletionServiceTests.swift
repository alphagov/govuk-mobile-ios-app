import Foundation
import CoreData
import Testing

@testable import govuk_ios

class CoreDataDeletionServiceTests {
    var mockCoreDataRepository: MockCoreDataRepository!

    deinit {
        mockCoreDataRepository.cleanUp()
    }

    @Test
    func deleteAllObjects_isSuccessful() throws {
        let entity1 = NSEntityDescription()
        entity1.name = "TestEntity1"
        entity1.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        let entity2 = NSEntityDescription()
        entity2.name = "TestEntity2"
        entity2.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        mockCoreDataRepository = MockCoreDataRepository(entities: [entity1, entity2])
        let object1 = NSEntityDescription.insertNewObject(
            forEntityName: "TestEntity1", into: mockCoreDataRepository.viewContext
        )
        let object2 = NSEntityDescription.insertNewObject(
            forEntityName: "TestEntity2", into: mockCoreDataRepository.viewContext
        )
        try mockCoreDataRepository.viewContext.save()
        var entitiy1Count: Int {
            try! mockCoreDataRepository.viewContext.count(
                for: NSFetchRequest(entityName: "TestEntity1")
            )
        }
        var entitiy2Count: Int {
            try! mockCoreDataRepository.viewContext.count(
                for: NSFetchRequest(entityName: "TestEntity2")
            )
        }
        let sut = CoreDataDeletionService(coreDataRespository: mockCoreDataRepository)

        #expect(entitiy1Count == 1)
        #expect(entitiy2Count == 1)

        try sut.deleteAllObjects()

        #expect(entitiy1Count == 0)
        #expect(entitiy2Count == 0)
    }
}
