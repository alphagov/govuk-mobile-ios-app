import Foundation
import UIKit

protocol DeeplinkRoute {
    var pattern: URLPattern { get }

    @MainActor
    func action(parent: BaseCoordinator,
                params: [String: String])
}
