import UIKit
@testable import govuk_ios

class MockHomeViewController: UIViewController,
                              ResetsToDefault {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var _hasResetState = false
    func resetState() {
        _hasResetState = true
    }
}
