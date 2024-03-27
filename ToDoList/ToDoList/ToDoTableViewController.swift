//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Diego Sierra on 22/03/24.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    let reuseIdentifier = "ToDoCellIdentifier"
    
    var toDos = [ToDo]()
    
    var filteredToDos: [ToDo]!
    
    var addNewToDoBarButton: UIBarButtonItem!
    
    var searchControllerBar: UISearchController!
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style()
    }
    
    
    // MARK: - Table view data source and delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchControllerBar.isActive && searchControllerBar.searchBar.text != "" {
            return filteredToDos.count
        }
        return toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for: indexPath) as! ToDoCell
        let toDo: ToDo
        
        if searchControllerBar.isActive && searchControllerBar.searchBar.text != "" {
            toDo = filteredToDos[indexPath.row]
        } else {
            toDo = toDos[indexPath.row]
        }
        cell.toDoTitleLabel.text = toDo.title
        cell.checkmarkButton.isSelected = toDo.isComplete
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDoDetailTableViewController = ToDoDetailTableViewController(style: .grouped)
        toDoDetailTableViewController.delegate = self
        toDoDetailTableViewController.toDo = toDos[indexPath.row]
        let navControllerToDoDetailTableViewController = UINavigationController(rootViewController: toDoDetailTableViewController)
        
        navigationController?.present(navControllerToDoDetailTableViewController, animated: true)
        
    }
}

// MARK: - Style method

extension ToDoTableViewController {
    private func style() {
        title = "My To-Dos"
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        
        addNewToDoBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewToDo))
        navigationItem.rightBarButtonItem = addNewToDoBarButton
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        searchControllerBar = UISearchController()
        searchControllerBar.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.searchController = searchControllerBar
    }
}

// MARK: - General methods

extension ToDoTableViewController {
    @objc func addNewToDo() {
        let toDoDetailTableViewController = ToDoDetailTableViewController(style: .grouped)
        toDoDetailTableViewController.delegate = self
        let navControllerToDoDetailTableViewController = UINavigationController(rootViewController: toDoDetailTableViewController)
        
        navigationController?.present(navControllerToDoDetailTableViewController, animated: true)
    }
    
    private func filterToDos(for searchText: String) {
        filteredToDos = toDos.filter { toDo in
            return toDo.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}


// MARK: - Protocol conformances

extension ToDoTableViewController: ToDoDetailTableViewControllerDelegate {
    func didSaveToDo(_ controller: ToDoDetailTableViewController, toDo: ToDo) {
        if let selectedToDo = tableView.indexPathForSelectedRow {
            toDos[selectedToDo.row] = toDo
            tableView.reloadRows(at: [selectedToDo], with: .automatic)
            tableView.deselectRow(at: selectedToDo, animated: true)
        } else {
            let newIndexPath = IndexPath(row: toDos.count, section: 0)
            self.toDos.append(toDo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        ToDo.saveToDos(toDos)
    }
}

extension ToDoTableViewController: ToDoCellDelegate {
    func checkMarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
}

extension ToDoTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterToDos(for: searchController.searchBar.text ?? "")
    }
}

// MARK: - Preview Provider
@available (iOS 17, *)
#Preview {
    let navController = UINavigationController(rootViewController: ToDoTableViewController(style: .plain))
    
    return navController
}
