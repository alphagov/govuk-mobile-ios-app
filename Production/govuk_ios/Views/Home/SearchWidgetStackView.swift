import UIKit
import UIComponents

class SearchWidgetStackView: UIStackView {
    private let viewModel: WidgetViewModel

    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.body
        localView.adjustsFontForContentSizeCategory = true
        localView.numberOfLines = 0
        localView.lineBreakMode = .byWordWrapping
        return localView
    }()

    private lazy var searchButton: UIButton = {
        let button = SearchModalButton()
        button.addTarget(
            self,
            action: #selector(searchButtonPressed),
            for: .touchUpInside
        )
        return button
    }()

    init(viewModel: WidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        spacing = 16
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(searchButton)
        titleLabel.text = viewModel.title
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
    }

    @objc
    private func searchButtonPressed() {
        viewModel.primaryAction?()
    }
}
