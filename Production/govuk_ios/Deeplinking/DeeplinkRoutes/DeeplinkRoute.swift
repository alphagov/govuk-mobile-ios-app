import Foundation
import UIKit

protocol DeeplinkRoute {
    var pattern: URLPattern { get }
    func action(parent: BaseCoordinator,
                params: [String: String])
}
