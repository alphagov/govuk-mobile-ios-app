import Foundation
import UIComponents
import GOVKit

protocol TopicDetailViewModelInterface: ObservableObject {
    var title: String { get }
    var description: String? { get }
    var sections: [GroupedListSection] { get }
    var errorViewModel: AppErrorViewModel? { get }
    func trackScreen(screen: TrackableScreen)
    var commerceItems: [ECommerceItem] { get set }
    func trackEcommerce()
}

extension TopicDetailViewModelInterface {
    func createCommerceEvent(_ name: String) -> AppEvent? {
        guard let commerceItem = commerceItems.first(where: { $0.name == name}) else {
            return nil
        }
        let event = AppEvent.selectItem(
            name: name,
            results: commerceItems.count,
            items: [commerceItem]
        )
        return event
    }

    func createCommerceItem(_ content: TopicDetailResponse.Content,
                            category: String) {
        let appEventItem = ECommerceItem(
            name: content.title,
            category: category,
            index: commerceItems.count + 1,
            itemId: nil,
            locationId: content.url.absoluteString
        )
        commerceItems.append(appEventItem)
    }
}
