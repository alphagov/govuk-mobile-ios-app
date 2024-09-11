@testable import govuk_ios
import CoreData
import XCTest
//
//final class RecentItemsViewModelTests: XCTestCase {
//    
//    var sut: RecentItemsViewModel?
//
//    override func tearDownWithError() throws {
//        sut = nil
//    }
//
//    func test_state_whenIsSetToLoaded_loadsRecentItems() throws {
//        //Given
//       let mockRecentItemsService = MockRecentItemsService()
//        sut = RecentItemsViewModel(service: mockRecentItemsService, activityRepository: ActivityRepository(coreData: CoreDataRepository(persistentContainer: <#T##NSPersistentContainer#>, notificationCenter: <#T##NotificationCenter#>)))
//        
//        let recentItems = [[
//            RecentItem(id: "ID",
//                 title: "Benefits",
//                 date: "2016-04-14T10:44:00+0000",
//                 url: "https://www.youtube.com/"),
//            RecentItem(id: "ID",
//                 title: "Benefits fraud",
//                 date: "2016-04-14T10:44:00+0000",
//                 url: "https://www.youtube.com/"),
//            RecentItem(id: "ID",
//                 title: "Universal",
//                 date: "2016-04-14T10:44:00+0000",
//                 url: "https://www.youtube.com/")],
//            [RecentItem(id: "ID",
//                 title: "Driving",
//                 date: "2003-04-14T10:44:00+0000",
//                 url: "https://www.youtube.com/")],
//            [RecentItem(id: "ID",
//                 title: "Benefits 2003",
//                 date: "2024-08-28T10:44:00+0000",
//                 url: "https://www.youtube.com/"),
//             RecentItem(id: "ID",
//                 title: "Benefits 2003",
//                 date: "2024-08-29T10:44:00+0000",
//                 url: "https://www.youtube.com/")
//        ]]
//        //When
//        mockRecentItemsService._receivedfetchItemsCompletion?(.success(recentItems))
//    
//        //Then
//        XCTAssertEqual(sut?.state, .loaded(RecentlyViewedViewStructure(todaysItems: [], thisMonthsItems: [], otherMonthItems: recentItems)))
//    }
//    
//    func test_state_whenSetToError_loadsErrorMessage() throws {
//        //Given
//        let mockRecentItemsService = MockRecentItemsService()
//        sut = RecentItemsViewModel(service: mockRecentItemsService)
//        
//        //When
//        mockRecentItemsService._receivedfetchItemsCompletion?(.failure(.noRecentlyVisitedItems))
//        
//        //Then
//        XCTAssertEqual(sut?.state, .error(RecentItemsErrorStructure(
//            errorTitle: NSLocalizedString("errorViewTitle",bundle: .main, comment: ""),
//            errrorDesc: NSLocalizedString("errorViewDescription", bundle: .main,comment: ""))
//        )
//        )
//    }
//    
//    func test_state_whenFetchItemsCompletionIsNotCalled_isSetToLoading() throws {
//        
//        //Given
//        let mockRecentItemsService = MockRecentItemsService()
//        sut = RecentItemsViewModel(service: mockRecentItemsService)
//        
//        //Then
//        XCTAssertEqual(sut?.state, .loading )
//    }
//}

