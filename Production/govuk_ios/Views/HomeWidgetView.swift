import UIKit
import Foundation

class HomeWidgetView: UIView {
    private lazy var stackView: UIStackView = {
        let localView = UIStackView()
        localView.axis = .vertical
        localView.alignment = .center
        localView.spacing = 8
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()
    private lazy var titleLabel: UILabel = {
        let localView = UILabel()
        localView.font = UIFont.systemFont(ofSize: 18)
        return localView
    }()
    private lazy var linkLabel: UILabel = {
        let localView = UILabel()
        localView.text = viewModel.link?["text"]
        localView.textColor = viewModel.linkColor
        localView.font = UIFont.systemFont(ofSize: 18)
        return localView
    }()

    private let viewModel: HomeWidgetViewModel

    init(viewModel: HomeWidgetViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.titleLabel.text = viewModel.title
        self.backgroundColor = viewModel.backgroundColor
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBorderColor() {
        layer.borderColor = viewModel.borderColor.cgColor
    }

    private func configureUI() {
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(linkLabel)
        updateBorderColor()
        linkLabel.isHidden = viewModel.link == nil
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 200),
            stackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 15
            ),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorderColor()
    }
}
