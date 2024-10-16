import Foundation
import UIKit

class AllTopicsViewController: BaseViewController, TrackableScreen {
    let viewModel: AllTopicsViewModel

    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(viewModel: AllTopicsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    var trackingName: String { "All topics" }
}
