import Foundation
import UIComponents
import GOVKit

protocol TopicDetailViewModelInterface: ObservableObject {
    var title: String { get }
    var isLoaded: Bool { get }
    var description: String? { get }
    var popularContent: CarouselCardGroup? { get }
    var sections: [GroupedListSection] { get }
    var subtopicCards: [ListCardViewModel] { get }
    var errorViewModel: AppErrorViewModel? { get }
    var commerceItems: [TopicCommerceItem] { get set }
    func trackScreen(screen: TrackableScreen)
    func trackEcommerce()
}

extension TopicDetailViewModelInterface {
    var subtopicCards: [ListCardViewModel] {
        []
    }

    var popularContent: CarouselCardGroup? {
        nil
    }

    func createCommerceEvent(_ name: String) -> AppEvent? {
        guard let commerceItem = commerceItems.first(where: { $0.name == name}) else {
            return nil
        }
        let event = AppEvent.selectTopicItem(
            name: name,
            results: commerceItems.count,
            items: [commerceItem]
        )
        return event
    }

    func createCommerceItem(_ content: TopicDetailResponse.Content,
                            category: String) {
        let appEventItem = TopicCommerceItem(
            name: content.title,
            category: category,
            index: commerceItems.count + 1,
            itemId: nil,
            locationId: content.url.absoluteString
        )
        commerceItems.append(appEventItem)
    }
}
