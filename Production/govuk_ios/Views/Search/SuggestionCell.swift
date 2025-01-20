import Foundation
import UIKit

class SuggestionCell: UITableViewCell {
    private var containerView: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        return localView
    }()

    private var titleLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.textColor = UIColor.govUK.text.primary
        localLabel.font = UIFont.govUK.body
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.numberOfLines = 0
        localLabel.lineBreakMode = .byWordWrapping
        return localLabel
    }()

    private var leftImageView: UIImageView = {
        let localImage = UIImageView()
        localImage.translatesAutoresizingMaskIntoConstraints = false
        localImage.image = UIImage(systemName: "magnifyingglass")
        localImage.tintColor = UIColor.govUK.text.secondary
        return localImage
    }()

    private var attributedTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.govUK.text.primary
        label.font = UIFont.govUK.body
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(suggestion: NSAttributedString) {
        attributedTitleLabel.attributedText = suggestion
    }

    private func setupUI() {
        selectionStyle = .none

        containerView.addSubview(leftImageView)
        containerView.addSubview(attributedTitleLabel)
        addSubview(containerView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.rightAnchor.constraint(
                equalTo: layoutMarginsGuide.rightAnchor
            ),
            containerView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            leftImageView.leftAnchor.constraint(
                equalTo: containerView.leftAnchor,
                constant: 4
            ),
            leftImageView.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            ),


            attributedTitleLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor, constant: 8
            ),
            attributedTitleLabel.rightAnchor.constraint(
                equalTo: containerView.rightAnchor, constant: -8
            ),
            attributedTitleLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: containerView.bottomAnchor, constant: -8
            ),
            attributedTitleLabel.leftAnchor.constraint(
                equalTo: leftImageView.rightAnchor, constant: 4
            )
        ])
    }
}
