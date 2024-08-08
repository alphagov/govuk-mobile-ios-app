import Foundation
import UIKit
import UIComponents

class SettingsViewController: BaseViewController,
                              TrackableScreen {
    var trackingName: String { "settingsscreen" }

    private var viewModel: SettingsViewModel

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.govUK.fills.surfaceBackground
    }
}
