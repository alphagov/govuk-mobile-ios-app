import Foundation

struct ActivityItemCreateParams {
    var id: String
    var title: String
    var date: Date
    var url: String
}

extension ActivityItemCreateParams {
    init(searchItem: SearchItem) {
        self.id = searchItem.link
        self.title = searchItem.title
        self.date = Date()
        self.url = searchItem.link
    }
}
