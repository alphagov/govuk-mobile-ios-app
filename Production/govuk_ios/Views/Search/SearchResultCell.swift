import UIKit
import UIComponents

class SearchResultCell: UITableViewCell {
    private lazy var card: UIView = {
        let localView = UIView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.backgroundColor = UIColor.govUK.fills.surfaceCard
        localView.layer.borderColor = UIColor.govUK.strokes.listDivider.cgColor
        localView.layer.borderWidth = 0.5
        localView.layer.cornerRadius = 10
        localView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16, leading: 16, bottom: 16, trailing: 16
        )

        return localView
    }()

    private let linkImage: UIImageView = {
        let localView = UIImageView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        localView.image = UIImage(systemName: "arrow.up.right")
        localView.tintColor = UIColor.govUK.text.link

        return localView
    }()

    private var titleLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.textColor = UIColor.govUK.text.link
        localLabel.numberOfLines = 0
        localLabel.lineBreakMode = .byWordWrapping
        localLabel.font = UIFont.govUK.body
        localLabel.textAlignment = .left
        localLabel.accessibilityHint = String.common.localized("openWebLinkHint")

        return localLabel
    }()

    private var bodyLabel: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.textColor = .label
        localLabel.font = UIFont.govUK.body
        localLabel.textAlignment = .left
        localLabel.numberOfLines = 0
        localLabel.lineBreakMode = .byWordWrapping

        return localLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstrains()
        card.isAccessibilityElement = true
        card.accessibilityTraits.insert(.link)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: SearchItem?) {
        titleLabel.text = item?.title
        let trimmedDescription = item?.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        bodyLabel.text = trimmedDescription
        card.accessibilityLabel = [
            titleLabel.text,
            bodyLabel.text
        ].compactMap { $0 }.joined(separator: ", ")
        card.accessibilityHint = String.common.localized("openWebLinkHint")
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.govUK.fills.surfaceModal

        contentView.addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(linkImage)
        card.addSubview(bodyLabel)
    }

    private func setupConstrains() {
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            card.leadingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.leadingAnchor
            ),
            card.trailingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.trailingAnchor
            ),
            card.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -16
            ),

            titleLabel.topAnchor.constraint(
                equalTo: card.layoutMarginsGuide.topAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.trailingAnchor,
                constant: -32
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.leadingAnchor
            ),

            linkImage.topAnchor.constraint(
                equalTo: titleLabel.topAnchor
            ),
            linkImage.trailingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.trailingAnchor
            ),

            bodyLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 8
            ),
            bodyLabel.trailingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.trailingAnchor
            ),
            bodyLabel.leadingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.leadingAnchor
            ),
            bodyLabel.bottomAnchor.constraint(
                equalTo: card.layoutMarginsGuide.bottomAnchor
            )
        ])
    }
}
