import UIKit
import UIComponents

class SearchWidgetStackView: UIStackView, WidgetInterface {
    var viewModel: HomeWidgetViewModel
    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.govUK.body
        return localView
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "magnifyingglass"
        )
        button.setImage(image, for: .normal)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(GOVUKColors.text.secondary, for: .normal)
        button.imageView?.tintColor = GOVUKColors.text.secondary
        button.backgroundColor = GOVUKColors.fills.surfaceSearchBox
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets.left = 8
        button.titleEdgeInsets.left = 13
        button.layer.cornerRadius = 10
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
        addArrangedSubview(titleLabel)
        addArrangedSubview(searchButton)
        titleLabel.text = viewModel.title
    }
    func configureConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: viewModel.widgetHeight),

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),

            searchButton.heightAnchor.constraint(equalToConstant: 36),
            searchButton.leftAnchor.constraint(equalTo: leftAnchor),
            searchButton.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    @objc
    private func searchButtonPressed() {
        viewModel.primaryAction?()
    }
}
