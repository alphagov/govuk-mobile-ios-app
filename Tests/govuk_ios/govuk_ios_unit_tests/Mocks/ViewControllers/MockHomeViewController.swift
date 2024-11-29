import UIKit
@testable import govuk_ios

class MockHomeViewController: UIViewController,
                              ContentScrollable {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var _didScrollToTop = false
    func scrollToTop() {
        _didScrollToTop = true
    }
}
