import UIKit
import UIComponents

class SearchResultCell: UITableViewCell {
    static let identifier = "SearchResult"

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
        localView.image = UIImage(systemName: "arrow.up.forward")
        localView.tintColor = UIColor.govUK.text.link

        return localView
    }()

    private let title: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.textColor = UIColor.govUK.text.link
        localLabel.numberOfLines = 0
        localLabel.lineBreakMode = .byWordWrapping
        localLabel.font = UIFont.govUK.body
        localLabel.textAlignment = .left
        localLabel.text = "The long title concerning coins andss" +
            " plastic teapots spanning multiple lines"

        return localLabel
    }()

    private let resultDescription: UILabel = {
        let localLabel = UILabel()
        localLabel.translatesAutoresizingMaskIntoConstraints = false
        localLabel.textColor = .label
        localLabel.font = UIFont.govUK.body
        localLabel.textAlignment = .left
        localLabel.numberOfLines = 0
        localLabel.lineBreakMode = .byWordWrapping
        localLabel.text = "This a lonnnnnnnng description" +
        " about top things to do with crisp packets and tig welding fingers"


        return localLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstrains()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none

        contentView.addSubview(card)
        card.addSubview(title)
        card.addSubview(linkImage)
        card.addSubview(resultDescription)
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

            title.topAnchor.constraint(
                equalTo: card.layoutMarginsGuide.topAnchor
            ),
            title.trailingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.trailingAnchor,
                constant: -32
            ),
            title.leadingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.leadingAnchor
            ),

            linkImage.trailingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.trailingAnchor
            ),
            linkImage.centerYAnchor.constraint(
                equalTo: title.centerYAnchor
            ),

            resultDescription.topAnchor.constraint(
                equalTo: title.bottomAnchor, constant: 8
            ),
            resultDescription.trailingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.trailingAnchor
            ),
            resultDescription.leadingAnchor.constraint(
                equalTo: card.layoutMarginsGuide.leadingAnchor
            ),
            resultDescription.bottomAnchor.constraint(
                equalTo: card.layoutMarginsGuide.bottomAnchor
            )
        ])
    }
}
