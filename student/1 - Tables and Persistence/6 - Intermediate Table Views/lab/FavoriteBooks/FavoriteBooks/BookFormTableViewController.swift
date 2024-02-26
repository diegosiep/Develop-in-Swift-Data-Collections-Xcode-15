//
//  BookFormTableViewController.swift
//  FavoriteBooks
//
//  Created by Diego Sierra on 23/02/24.
//

import UIKit

protocol BookFormTableViewControllerDelegate {
    func saveBook(book: Book)
}

class BookFormTableViewController: UITableViewController {
    let bookTitleTableViewCell = UITableViewCell(style: .default, reuseIdentifier: "BookTitleCell")
    let bookTitleTextField = UITextField()
    
    let authorTableViewCell = UITableViewCell(style: .default, reuseIdentifier: "AuthorCell")
    let authorTextField = UITextField()
    
    let genreTableViewCell = UITableViewCell(style: .default, reuseIdentifier: "GenreCell")
    let genreTextField = UITextField()
    
    let lengthTableViewCell = UITableViewCell(style: .default, reuseIdentifier: "LengthCell")
    let lengthTextField = UITextField()
    
    let saveTableViewCell = UITableViewCell(style: .default, reuseIdentifier: "SaveCell")
    let saveButton = UIButton(configuration: .borderless())
    
    var delegate: BookFormTableViewControllerDelegate?
    
    var book: Book?
    init(book: Book? = nil) {
        self.book = book
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updateUI(with: book)
        
    }
    
    // MARK: - Table view data source and delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = bookTitleTableViewCell
        case 1:
            cell = authorTableViewCell
        case 2:
            cell = genreTableViewCell
        case 3:
            cell = lengthTableViewCell
        case 4:
            cell = saveTableViewCell
        default:
            fatalError("Something went wrong")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            "Title"
        case 1:
            "Author"
        case 2:
            "Genre"
        case 3:
            "Length"
        case 4:
            ""
        default:
            fatalError("Something went wrong")
        }
    }
}


// MARK: - style and layout methods for TableViewController

extension BookFormTableViewController {
    func style() {
        tableView.rowHeight = 50
        bookTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        if let selectedBook = book {
            bookTitleTextField.text = selectedBook.title
        }
        bookTitleTableViewCell.contentView.addSubview(bookTitleTextField)
        
        authorTextField.translatesAutoresizingMaskIntoConstraints = false
        authorTableViewCell.contentView.addSubview(authorTextField)
        
        genreTextField.translatesAutoresizingMaskIntoConstraints = false
        genreTableViewCell.contentView.addSubview(genreTextField)
        
        lengthTextField.translatesAutoresizingMaskIntoConstraints = false
        lengthTableViewCell.contentView.addSubview(lengthTextField)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveBookToTableViewController), for: .touchUpInside)
        saveTableViewCell.contentView.addSubview(saveButton)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            bookTitleTextField.topAnchor.constraint(equalTo: bookTitleTableViewCell.contentView.topAnchor, constant: 16),
            bookTitleTextField.leadingAnchor.constraint(equalTo: bookTitleTableViewCell.contentView.leadingAnchor, constant: 16),
            bookTitleTableViewCell.contentView.trailingAnchor.constraint(equalTo: bookTitleTextField.trailingAnchor, constant: 16),
            
            authorTextField.topAnchor.constraint(equalTo: authorTableViewCell.contentView.topAnchor, constant: 16),
            authorTextField.leadingAnchor.constraint(equalTo: authorTableViewCell.contentView.leadingAnchor, constant: 16),
            authorTableViewCell.contentView.trailingAnchor.constraint(equalTo: authorTextField.trailingAnchor, constant: 16),
            
            genreTextField.topAnchor.constraint(equalTo: genreTableViewCell.contentView.topAnchor, constant: 16),
            genreTextField.leadingAnchor.constraint(equalTo: genreTableViewCell.contentView.leadingAnchor, constant: 16),
            genreTableViewCell.contentView.trailingAnchor.constraint(equalTo: genreTextField.trailingAnchor, constant: 16),
            
            lengthTextField.topAnchor.constraint(equalTo: lengthTableViewCell.contentView.topAnchor, constant: 16),
            lengthTextField.leadingAnchor.constraint(equalTo: lengthTableViewCell.contentView.leadingAnchor, constant: 16),
            lengthTableViewCell.contentView.trailingAnchor.constraint(equalTo: lengthTextField.trailingAnchor, constant: 16),
            
            saveButton.topAnchor.constraint(equalTo: saveTableViewCell.contentView.topAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: saveTableViewCell.contentView.leadingAnchor, constant: 16),
            saveTableViewCell.contentView.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 16),
            saveTableViewCell.contentView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16)
            
        ])
    }
}


// MARK: - General methods

extension BookFormTableViewController {
    func updateUI(with book: Book?) {
        if let selectedBook = book {
            bookTitleTextField.text = selectedBook.title
            authorTextField.text = selectedBook.author
            genreTextField.text = selectedBook.genre
            lengthTextField.text = selectedBook.length
        }
    }
    
    @objc func saveBookToTableViewController() {
        let editedOrAddedBook = Book(title: bookTitleTextField.text ?? "", author: authorTextField.text ?? "", genre: genreTextField.text ?? "", length: lengthTextField.text ?? "")
        self.delegate?.saveBook(book: editedOrAddedBook)
        dismiss(animated: true)
        
    }
}

@available(iOS 17, *)
#Preview {
    BookFormTableViewController(book: nil)
}

