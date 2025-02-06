import Foundation
import GOVKit
import UIKit

class WidgetBuilder: NSObject {
    weak var coordinator: BaseCoordinator?

    private let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void
    let searchAction: () -> Void
    let recentActivityAction: () -> Void

    init(coordinator: BaseCoordinator? = nil,
         analytics: AnalyticsServiceInterface,
         configService: AppConfigServiceInterface,
         topicWidgetViewModel: TopicsWidgetViewModel,
         feedbackAction: @escaping () -> Void,
         searchAction: @escaping () -> Void,
         recentActivityAction: @escaping () -> Void) {
        self.coordinator = coordinator
        self.analyticsService = analytics
        self.configService = configService
        self.topicWidgetViewModel = topicWidgetViewModel
        self.feedbackAction = feedbackAction
        self.searchAction = searchAction
        self.recentActivityAction = recentActivityAction
    }

    func loadWidgets() -> [WidgetDescriptor] {
        guard let widgetPath = Bundle.main.path(forResource: "Widgets", ofType: "json")
        else {
            return []
        }
        FileManager.default.fileExists(atPath: widgetPath)

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: widgetPath))
            let widgetList = try JSONDecoder().decode(WidgetList.self, from: data)
            return widgetList.widgets.filter { $0.enabled }.sorted(by: { $0.rank < $1.rank })
        } catch {
            print(error)
            return []
        }
    }

    func getAll() -> [WidgetView] {
        var widgetViews = [WidgetView]()
        let widgetList = loadWidgets()
        widgetList.forEach {
            if let type = NSClassFromString($0.name) as? NSObject.Type {
                if let provider = type.init() as? WidgetProviding {
                    print($0.name + " is a provider")
                    configureWidget(provider: provider)
                    widgetViews.append(provider.widget)
                }
            } else {
                print("couldn't find " + $0.name)
            }
        }
        return widgetViews
    }

    func configureWidget(provider: WidgetProviding) {
        let viewModel = WidgetViewModel(title: provider.title,
                                        action: widgetAction(provider))
        provider.configure(viewModel: viewModel)
    }

    private func widgetAction(_ provider: WidgetProviding) -> () -> Void {
        switch provider.actionType {
        case .push:
            return pushAction(provider)
        case .url:
            return urlAction(provider)
        case .present:
            return { }
        case .custom(let name):
            switch name {
            case "search":
                return searchAction
            case "recentActivity":
                return recentActivityAction
            default:
                return { }
            }
        }
    }

    private func pushAction(_ provider: WidgetProviding) -> () -> Void {
        return { [weak self] in
            guard let root = self?.coordinator?.root else { return }
            self?.trackWidgetNavigation(text: provider.title)
            let widgetCoordinator = WidgetCoordinator(
                navigationController: root
            )
            if let type = provider.startViewController {
                let viewController = type.init()
                if var analyticsProviding = viewController as? AnalyticsProviding {
                    analyticsProviding.analyticsService = self?.analyticsService
                }
                widgetCoordinator.viewController = viewController
            }
            self?.coordinator?.start(widgetCoordinator)
        }
    }

    private func urlAction(_ provider: WidgetProviding) -> () -> Void {
        return {
            guard let urlString = provider.urlString else { return }
            self.trackWidgetNavigation(text: provider.title,
                                       external: true)
            let urlOpener: URLOpener = UIApplication.shared
            urlOpener.openIfPossible(urlString)
        }
    }

    private func trackWidgetNavigation(text: String,
                                       external: Bool = false) {
        let event = AppEvent.widgetNavigation(
            text: text,
            external: external
        )
        analyticsService.track(event: event)
    }
}

struct WidgetList: Codable {
    let widgets: [WidgetDescriptor]
}

struct WidgetDescriptor: Codable {
    let name: String
    let rank: Int
    let enabled: Bool
}
