import UIKit
import UIComponents

class SearchHistoryCell: UITableViewCell {
    private let deleteButton: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.image = UIImage(systemName: "xmark")
        buttonConfig.baseForegroundColor = UIColor.govUK.text.trailingIcon
        buttonConfig.baseBackgroundColor = .clear
        buttonConfig.contentInsets = .zero

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        buttonConfig.preferredSymbolConfigurationForImage = imageConfig

        let localButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        localButton.configuration = buttonConfig
        localButton.contentHorizontalAlignment = .trailing
        localButton.accessibilityLabel = String.search.localized("removeSearchAccessibilityTitle")
        return localButton
    }()

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

    var searchText: String? {
        didSet {
            var contentConfig = createContentConfiguration()
            contentConfig.text = searchText
            self.contentConfiguration = contentConfig
        }
    }

    var deleteAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        accessoryView = deleteButton
        selectionStyle = .none
        separatorInset.left = 0
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        deleteButton.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let accessoryView {
            var frame = accessoryView.frame
            frame.origin.x = self.bounds.width - frame.width - 8
            accessoryView.frame = frame
        }
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

    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
}
