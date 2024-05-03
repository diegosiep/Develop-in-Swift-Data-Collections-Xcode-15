//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Diego Sierra on 30/04/24.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    static let reuseIdentifier = "CategoryCell"
    
    var categories = [String]()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuTableViewController = MenuTableViewController(category: categories[indexPath.row])
        guard let menuTableViewController = menuTableViewController else { return }
        navigationController?.pushViewController(menuTableViewController, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        configureCell(cell, forCategoryAt: indexPath)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Style and layout methods

extension CategoryTableViewController {
    private func style() {
        title = "Restaurant"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoryTableViewController.reuseIdentifier)
        
        Task.init {
            do {
                let categories = try await MenuController.shared.fetchCategories()
                updateUI(with: categories)
            } catch {
                displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }
    
    private func layout() {

    }
    
   
}

// MARK: - General methods

extension CategoryTableViewController {
    private func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.capitalized
        cell.contentConfiguration = content
    }
    
    func updateUI(with categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
}

// MARK: - Preview Provider

@available (iOS 17, *)

#Preview {
    UINavigationController(rootViewController: CategoryTableViewController(style: .insetGrouped))
}
