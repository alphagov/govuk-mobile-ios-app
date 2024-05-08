import UIKit

class ViewController: UIViewController {
    private let color: UIColor

    init(color: UIColor,
         tabTitle: String) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
        self.title = tabTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }

    private func fakeMethodNotCalled() {
        print("Here is some codez")
    }

}
