import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct SearchHistoryRepositoryTests {

    @Test func save_newSearchHistoryItem_savesObject() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = SearchHistoryRepository(
            coreData: coreData
        )
        
        let expectedSearchString = UUID().uuidString
        let expectedDate = Date()
        
        sut.save(searchText: expectedSearchString,
                 date: expectedDate)
        let items = try #require(sut.fetchedResultsController?.fetchedObjects)

        #expect(items.count == 1)
        #expect(items.first?.searchText == expectedSearchString)
        #expect(items.first?.date == expectedDate)
    }

    @Test
    func save_usingExistingSearchText_updatesObject() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = SearchHistoryRepository(
            coreData: coreData
        )
        
        let expectedSearchString = UUID().uuidString
        let expectedDate = Date()
        
        sut.save(searchText: expectedSearchString,
                 date: expectedDate)
        let items = try #require(sut.fetchedResultsController?.fetchedObjects)
        #expect(items.count == 1)
        
        let updatedDate = Date() + 10
        sut.save(searchText: expectedSearchString,
                 date: updatedDate)
        let updatedItems = try #require(sut.fetchedResultsController?.fetchedObjects)
        #expect(updatedItems.count == 1)
        #expect(updatedItems.first?.searchText == expectedSearchString)
        #expect(updatedItems.first?.date == updatedDate)
    }
    
    @Test
    func save_prunesItems() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = SearchHistoryRepository(
            coreData: coreData
        )
        
        for _ in 0..<5 {
            sut.save(searchText: UUID().uuidString,
                     date: .init())
        }
        
        var items = try #require(sut.fetchedResultsController?.fetchedObjects)
        #expect(items.count == 5)
        
        sut.save(searchText: "latest search",
                 date: .init())
        items = try #require(sut.fetchedResultsController?.fetchedObjects)
        #expect(items.count == 5)
        #expect(items.first?.searchText == "latest search")
    }
    
    @Test
    func clear_removesAllItems() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
        let sut = SearchHistoryRepository(
            coreData: coreData
        )
        
        for _ in 0..<5 {
            sut.save(searchText: UUID().uuidString,
                     date: .init())
        }
        
        var items = try #require(sut.fetchedResultsController?.fetchedObjects)
        #expect(items.count == 5)
        
        sut.clearSearchHistory()
        items = try #require(sut.fetchedResultsController?.fetchedObjects)
        #expect(items.count == 0)
    }
}
