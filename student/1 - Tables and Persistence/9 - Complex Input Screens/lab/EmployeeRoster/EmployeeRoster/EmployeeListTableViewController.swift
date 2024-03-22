
import UIKit

class EmployeeListTableViewController: UITableViewController {
    
    var employees: [Employee] = []
    
    var employeeCell = UITableViewCell(style: .subtitle, reuseIdentifier: "EmployeeCell")
    
    var addNewEmployeeBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    // MARK: - Table view data source and delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCell.reuseIdentifier!, for: indexPath)
        
        let employee = employees[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = employee.name
        content.secondaryText = employee.employeeType.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeeDetailTableViewController = EmployeeDetailTableViewController(style: .grouped)
        employeeDetailTableViewController.delegate = self
        employeeDetailTableViewController.employee = employees[indexPath.row]
        let detailNavController = UINavigationController(rootViewController: employeeDetailTableViewController)
        navigationController?.present(detailNavController, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            employees.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


// MARK: - EmployeeDetailTableViewControllerDelegate

extension EmployeeListTableViewController: EmployeeDetailTableViewControllerDelegate {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee) {
        if let indexPath = tableView.indexPathForSelectedRow {
            employees.remove(at: indexPath.row)
            employees.insert(employee, at: indexPath.row)
        } else {
            employees.append(employee)
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Style methods

extension EmployeeListTableViewController {
    func style() {
        title = "Employees"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeCell.reuseIdentifier!)
        
        addNewEmployeeBarButton.image = UIImage(systemName: "plus")
        addNewEmployeeBarButton.target = self
        addNewEmployeeBarButton.action = #selector(addNewEmployee)
        navigationItem.rightBarButtonItem = addNewEmployeeBarButton
    }
}

// MARK: - General methods

extension EmployeeListTableViewController {
    @objc func addNewEmployee() {
        let employeeDetailTableViewController = EmployeeDetailTableViewController(style: .grouped)
        employeeDetailTableViewController.delegate = self
        employeeDetailTableViewController.employee = nil
        let navController = UINavigationController(rootViewController: employeeDetailTableViewController)
        
        navigationController?.present(navController, animated: true)
    }
}
// MARK: - Preview Provider

@available (iOS 17, *)
#Preview {
    let navController = UINavigationController(rootViewController: EmployeeListTableViewController())
    
    return navController
}
