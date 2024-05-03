//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Diego Sierra on 30/04/24.
//

import UIKit

class MenuTableViewController: UITableViewController {
    static let reuseIdentifier = "MenuCell"
    
    var menuCell: MenuTableViewCell!
    
    let category: String
    var menuItems = [MenuItem]()
    
    init?(category: String) {
        self.category = category
        super.init(style: .plain)
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
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItemDetailViewController = MenuItemDetailViewController(menuitem: menuItems[indexPath.row])
        guard let menuItemDetailViewController = menuItemDetailViewController else { return }
    
        navigationController?.pushViewController(menuItemDetailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        menuCell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as? MenuTableViewCell
        menuCell.accessoryType = .disclosureIndicator
        configureCell(menuCell, forItemAt: indexPath)
        
        return menuCell
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

extension MenuTableViewController {
    
    private func style() {
        title = category.capitalized
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        
        Task.init {
            do {
                let menuItems = try await MenuController.shared.fetchMenuItems(forCategory: self.category)
                self.updateUI(with: menuItems)
                
            } catch {
                displayError(error, title: "Failed to fetch Menu Items for \(self.category)")
            }
        }
    }
    
    private func layout() {
        
    }
    
}

// MARK: - General methods

extension MenuTableViewController {
    private func configureCell(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = contentConfiguration
    }
    
    private func updateUI(with menuItems: [MenuItem]) {
        self.menuItems = menuItems
        tableView.reloadData()
    }
    
    private func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alertViewController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alertViewController, animated: true)
    }
}

// MARK: - ReusableCell

extension MenuTableViewController {
    class MenuTableViewCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value2, reuseIdentifier: MenuTableViewController.reuseIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - PreviewProvider

@available (iOS 17, *)

#Preview {
    UINavigationController(rootViewController: MenuTableViewController(category: "appetizers")!)
}
