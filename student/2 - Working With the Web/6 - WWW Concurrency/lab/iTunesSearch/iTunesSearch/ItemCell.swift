
import UIKit

class ItemCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var name: String? = nil
    {
        didSet {
            // Ensure that an update is performed whenever this property changes.
            if oldValue != name {
                setNeedsUpdateConfiguration()
            }
        }
    }
    var artist: String? = nil
    {
        didSet {
            // Ensure that an update is performed whenever this property changes.
            if oldValue != artist {
                setNeedsUpdateConfiguration()
            }
        }
    }
    var artworkImage: UIImage? = nil
    {
        didSet {
            if oldValue != artworkImage {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)

        // set content's text to the item's name
        content.text = name

        // set content's secondary text to the item's artist
        content.secondaryText = artist

        // configure the image display properties for the content image based on
        // the existance of the artworkImage
        content.imageProperties.reservedLayoutSize = CGSize(width: 100.0, height: 200.0)
        if let image = artworkImage {
            content.image = image
        } else {
            // set set content's image to the system image "photo"
            content.image = UIImage(systemName: "photo")
            content.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 75.0)
            content.imageProperties.tintColor = .lightGray
        }
        
        self.contentConfiguration = content
    }
}

// MARK: - PreviewProvider

@available (iOS 17, *)

#Preview(traits: .fixedLayout(width: 100, height: 100), body: {
    ItemCell()
}) 
