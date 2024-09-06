import Foundation

final class MockRecentItemsService: RecentItemsServiceInterface {
    
    var _receivedfetchItemsCompletion: ((Result<[[RecentItem]], RecentItemsError>) -> Void)?
    
    func fetchItems(completion: @escaping (Result<[[RecentItem]], RecentItemsError>) -> Void) {
        _receivedfetchItemsCompletion = completion
    }
}
