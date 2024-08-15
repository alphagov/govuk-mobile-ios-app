import UIKit
import UIComponents

class SearchWidgetStackView: UIStackView, WidgetInterface {
    var viewModel: HomeWidgetViewModel
    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.body
        return localView
    }()

    init(viewModel: HomeWidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        addArrangedSubview(titleLabel)
        titleLabel.text = viewModel.title
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
