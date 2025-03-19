import Foundation
import UIKit

class SuggestionCell: UITableViewCell {
    private let magnifyingImage: UIImage? = {
        var image = UIImage(systemName: "magnifyingglass")
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 12,
            weight: .bold,
            scale: .large
        )
        image = image?.withConfiguration(imageConfig)
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(suggestion: NSAttributedString) {
        var content = createContentConfiguration()
        content.attributedText = suggestion
        contentConfiguration = content
    }

    private func configureUI() {
        selectionStyle = .none
        separatorInset.left = 0
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    private func createContentConfiguration() -> UIListContentConfiguration {
        var config = self.defaultContentConfiguration()
        config.textProperties.font = UIFont.govUK.body
        config.image = magnifyingImage
        config.imageProperties.tintColor = UIColor.govUK.text.secondary
        config.imageToTextPadding = 3
        config.axesPreservingSuperviewLayoutMargins = .vertical
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8
        )
        return config
    }
}
