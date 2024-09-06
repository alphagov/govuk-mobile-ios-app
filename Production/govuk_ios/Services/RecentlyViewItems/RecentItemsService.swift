import Foundation

protocol RecentItemsServiceInterface {
    func fetchItems(completion: @escaping(Result<[[RecentItem]], RecentItemsError>) -> Void)
}

class RecentItemsService: RecentItemsServiceInterface {
    func fetchItems(
        completion: @escaping (Result<[[RecentItem]], RecentItemsError>) -> Void) {
            completion(.success([[
                RecentItem(id: "ID",
                     title: "Benefits",
                     date: "2016-04-14T10:44:00+0000",
                     url: "https://www.youtube.com/"),
                RecentItem(id: "ID",
                     title: "Benefits fraud",
                     date: "2016-04-14T10:44:00+0000",
                     url: "https://www.youtube.com/"),
                RecentItem(id: "ID",
                     title: "Universal",
                     date: "2016-04-14T10:44:00+0000",
                     url: "https://www.youtube.com/")],
                [RecentItem(id: "ID",
                     title: "Driving",
                     date: "2003-04-14T10:44:00+0000",
                     url: "https://www.youtube.com/")],
                [RecentItem(id: "ID",
                     title: "Benefits 2003",
                     date: "2024-08-28T10:44:00+0000",
                     url: "https://www.youtube.com/"),
                 RecentItem(id: "ID",
                     title: "Benefits 2003",
                     date: "2024-08-29T10:44:00+0000",
                     url: "https://www.youtube.com/")
            ]]))
    }
}
