//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Diego Sierra on 20/03/24.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate: AnyObject {
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employee: EmployeeType?)
}

class EmployeeTypeTableViewController: UITableViewController {
    let employeeTypeCell = UITableViewCell(style: .default, reuseIdentifier: "EmployeeTypeCell")
    
    var employeeType: EmployeeType?
    
    var delegate: EmployeeTypeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Table view data source and delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeTypeCell.reuseIdentifier!, for: indexPath)
        
        let type = EmployeeType.allCases[indexPath.row]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = type.description
        cell.contentConfiguration = contentConfiguration
        
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeType = EmployeeType.allCases[indexPath.row]
        delegate?.employeeTypeTableViewController(self, didSelect: employeeType)
        
        tableView.reloadData()
    }
    
}

// MARK: - Style methods
extension EmployeeTypeTableViewController {
    private func style() {
        title = "Select Employee Type"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeTypeCell.reuseIdentifier!)
        
        
    }
}

// MARK: - PreviewProvider


@available (iOS 17, *)
#Preview {
    let navController = UINavigationController(rootViewController: EmployeeTypeTableViewController(style: .grouped))
    return navController
}
