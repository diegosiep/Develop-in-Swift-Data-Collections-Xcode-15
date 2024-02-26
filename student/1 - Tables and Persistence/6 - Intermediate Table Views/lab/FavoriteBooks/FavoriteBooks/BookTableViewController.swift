import UIKit

class BookTableViewController: UITableViewController {
    
    var books: [Book] = []
    let addBookButton = UIBarButtonItem(image: UIImage(systemName: "plus"))
    var bookFormTableViewController: BookFormTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source and delegate mthods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseIdentifier, for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]
        cell.configureCell(with: book)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.row]
        bookFormTableViewController = BookFormTableViewController(book: selectedBook)
        guard let bookFormTableViewController = bookFormTableViewController else { return }
        bookFormTableViewController.delegate = self
        bookFormTableViewController.title = "Edit New Book"
        navigationController?.present(UINavigationController(rootViewController: bookFormTableViewController), animated: true)
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

// MARK: - Setup and style methods for UITableViewController

extension BookTableViewController {
    func style() {
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
        navigationItem.rightBarButtonItem = addBookButton
        addBookButton.target = self
        addBookButton.action = #selector(addNewBook)
        title = "Favourite Books"
    }
    
    func layout() {
        
    }
}


// MARK: - General methods
extension BookTableViewController {
    @objc func addNewBook() {
        bookFormTableViewController = BookFormTableViewController(book: nil)
        guard let bookFormTableViewController = bookFormTableViewController else { return }
        bookFormTableViewController.delegate = self
        bookFormTableViewController.title = "Add New Book"
        navigationController?.present(UINavigationController(rootViewController: bookFormTableViewController), animated: true)
    }
}

// MARK: - Protocol conformances

extension BookTableViewController: BookFormTableViewControllerDelegate {
    func saveBook(book: Book) {
        if let selectedBookIndexPath = tableView.indexPathForSelectedRow {
            books[selectedBookIndexPath.row] = book
            tableView.reloadRows(at: [selectedBookIndexPath], with: .automatic)
        
        } else {
            books.append(book)
            tableView.reloadData()
        }
    }
}




// MARK: - Preview provider
@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: BookTableViewController())
}
