//

import Foundation
import UIKit

protocol DeepLink {
    var path: String { get set }
    var navigationController:UINavigationController? { get set }
    var isAvailable:Bool { get set }
    func displayUnavailableAlert()
    func action()
}
