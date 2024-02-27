//
//  EmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Diego Sierra on 15/02/24.
//

import UIKit


class EmojiTableViewCell: UITableViewCell {
    static let reuseIdentifier = "EmojiCell"
    
    let symbolAndLabelsStackView = UIStackView()
    let verticalStackView = UIStackView()
    let emojiSymbolLabel = UILabel()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        
    }
    
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: setup, layout and configuration methods
extension EmojiTableViewCell {
    func setup() {
        contentView.addSubview(symbolAndLabelsStackView)
        
        symbolAndLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        symbolAndLabelsStackView.axis = .horizontal
        symbolAndLabelsStackView.spacing = 8
        symbolAndLabelsStackView.addArrangedSubview(emojiSymbolLabel)
        symbolAndLabelsStackView.addArrangedSubview(verticalStackView)
        
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
  
        
        emojiSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiSymbolLabel.text = "😃"
        emojiSymbolLabel.font = .systemFont(ofSize: 24)
        emojiSymbolLabel.textAlignment = .center
        emojiSymbolLabel.adjustsFontSizeToFitWidth = true
        emojiSymbolLabel.setContentHuggingPriority(.init(252), for: .horizontal)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .title3)
        nameLabel.text = "Happy Face"
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Happy Mood"
    
        
        
    
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            symbolAndLabelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: symbolAndLabelsStackView.bottomAnchor, constant: 8),
            symbolAndLabelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: symbolAndLabelsStackView.trailingAnchor, constant: 16),
        

        ])
        
    }
    
    func configureCell(with emoji: Emoji) {
        emojiSymbolLabel.text = emoji.symbol
        nameLabel.text = emoji.name
        descriptionLabel.text = emoji.description
    }
}

@available(iOS 17, *)
#Preview(nil, traits: .fixedLayout(width: 300, height: 60), body: {
    EmojiTableViewCell()
})

        


