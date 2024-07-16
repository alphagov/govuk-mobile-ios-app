import UIKit
import Foundation

@testable import govuk_ios

class MockBaseCoordinator: BaseCoordinator {
    
    convenience init() {
        self.init(navigationController: .init())
    }
    
    var _startCalled: Bool = false
    override func start() {
        _startCalled = true
    }
    
}
