import Foundation
import Testing
import GOVKit
import CoreData

@testable import govuk_ios

@Suite
struct SearchHistoryViewControllerTest {

//    @Test
//    func announce_noPreviousSearches_doesntAnnounce() {
//        let mockAccessibilityAnnouncerService = MockAccessibilityAnnouncerService()
//        let viewModel = MockSearchHistoryViewModel()
//        viewModel._stubbedSearchHistoryItems = []
//        let sut = SearchHistoryViewController(
//            viewModel: viewModel,
//            accessibilityAnnouncer: mockAccessibilityAnnouncerService,
//            selectionAction: { _ in }
//        )
//
//        sut.announce()
//
//        #expect(mockAccessibilityAnnouncerService._receivedAnnounceValue == nil)
//    }

//    @Test
//    func announce_previousSearches_announces() {
//        let mockAccessibilityAnnouncerService = MockAccessibilityAnnouncerService()
//
//        let coreData = CoreDataRepository.arrangeAndLoad
//        let item = SearchHistoryItem(context: coreData.viewContext)
//        item.searchText = "Test search"
//        item.date = Date()
//        try! coreData.viewContext.save()
//
//        let viewModel = MockSearchHistoryViewModel()
//        viewModel._stubbedSearchHistoryItems = []
//
//        let sut = SearchHistoryViewController(
//            viewModel: viewModel,
//            accessibilityAnnouncer: mockAccessibilityAnnouncerService,
//            selectionAction: { _ in }
//        )
//
//        sut.announce()
//
//        #expect(mockAccessibilityAnnouncerService._receivedAnnounceValue == nil)
//    }
}
