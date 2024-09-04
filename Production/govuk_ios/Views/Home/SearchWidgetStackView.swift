import UIKit
import UIComponents

class SearchWidgetStackView: UIStackView, WidgetInterface {
    var viewModel: HomeWidgetViewModel

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
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()

    init(viewModel: HomeWidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        distribution = .fill
        addArrangedSubview(titleLabel)
        addArrangedSubview(searchButton)
        titleLabel.text = viewModel.title
    }
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),

            searchButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            searchButton.leftAnchor.constraint(equalTo: leftAnchor),
            searchButton.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    @objc
    func searchButtonPressed() {
        viewModel.primaryAction?()
    }
}
