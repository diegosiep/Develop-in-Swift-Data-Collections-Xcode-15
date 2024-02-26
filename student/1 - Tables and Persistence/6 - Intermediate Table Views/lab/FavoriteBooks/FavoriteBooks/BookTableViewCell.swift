//
//  BookTableViewCell.swift
//  FavoriteBooks
//
//  Created by Diego Sierra on 26/02/24.
//

import UIKit

class BookTableViewCell: UITableViewCell {
static let reuseIdentifier = "BookCell"
    let verticalStackView = UIStackView()
    let horizontalStackView = UIStackView()
    let bookTitleLabel = UILabel()
    let authorLabel = UILabel()
    let genreLabel = UILabel()
    let lengthLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleForCell()
        layoutForCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - Layout and style methods for UITabelViewCell
extension BookTableViewCell {
    func layoutForCell() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            
            
        ])
    }
    
    func styleForCell() {
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.addArrangedSubview(bookTitleLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.distribution = .fillEqually
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.addArrangedSubview(authorLabel)
        horizontalStackView.addArrangedSubview(genreLabel)
        horizontalStackView.addArrangedSubview(lengthLabel)
        horizontalStackView.distribution = .equalSpacing
        
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bookTitleLabel.font = .systemFont(ofSize: 30)
        bookTitleLabel.adjustsFontSizeToFitWidth = true
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.adjustsFontForContentSizeCategory = true
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.adjustsFontForContentSizeCategory = true
        
        lengthLabel.translatesAutoresizingMaskIntoConstraints = false
        lengthLabel.adjustsFontForContentSizeCategory = true
        
    }
    
    func configureCell(with book: Book) {
        bookTitleLabel.text = book.title
        authorLabel.text = book.author
        genreLabel.text = book.genre
        lengthLabel.text = book.length
    }
    
}

// MARK: - Preview provider
@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 100), body: {
    let bookTableViewCell = BookTableViewCell(style: .default, reuseIdentifier: BookTableViewCell.reuseIdentifier)
    bookTableViewCell.configureCell(with: Book(title: "Harry Potter", author: "J.K. Rowling", genre: "Fantasy", length: "690"))
    return bookTableViewCell
    
})
