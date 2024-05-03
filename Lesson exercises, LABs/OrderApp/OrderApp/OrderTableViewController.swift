//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Diego Sierra on 30/04/24.
//

import UIKit

class OrderTableViewController: UITableViewController {
    static let reuseIdentifier = "OrderTableViewCell"
    
    var orderTableViewCell: OrderTableViewCell!
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return MenuController.shared.order.menuItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as! OrderTableViewCell
        configureCell(with: MenuController.shared.order.menuItems[indexPath.row], for: cell)
        
        
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

// MARK: - Style and layoout methods

extension OrderTableViewController {
    private func style() {
        orderTableViewCell = OrderTableViewCell()
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
    }
    
    private func layout() {
        
    }
}

// MARK: - General methods

extension OrderTableViewController {
    private func configureCell(with menuItem: MenuItem, for cell: OrderTableViewCell) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = contentConfiguration
    }
}

// MARK: - TableViewCell Class to display

extension OrderTableViewController {
    class OrderTableViewCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .value2, reuseIdentifier: OrderTableViewController.reuseIdentifier)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - PreviewProvider

@available (iOS 17, *)

#Preview {
    UINavigationController(rootViewController: OrderTableViewController(style: .plain))
}
