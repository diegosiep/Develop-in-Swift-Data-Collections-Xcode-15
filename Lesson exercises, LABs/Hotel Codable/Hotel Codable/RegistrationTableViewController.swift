//
//  RegistrationTableViewController.swift
//  Hotel Codable
//
//  Created by Diego Sierra on 06/03/24.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    let registrationCell = UITableViewCell(style: .subtitle, reuseIdentifier: "RegistrationCell")
    var registrations: [Registration] = [Registration(firstName: "Mary", lastName: "Something", emailAddress: "dkweode", checkInDate: Date(), checkOutDate: Date(), numberOfAdults: 3, numberOfChildren: 3, wifi: true, roomType: RoomType(id: 3, name: "Penthouse Suite", shortName: "", price: 89))]
    
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
        return registrations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: registrationCell.reuseIdentifier!, for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = "\(registrations[indexPath.row].firstName)" + " " + "\(registrations[indexPath.row].lastName)"
        contentConfiguration.secondaryText = (registrations[indexPath.row].checkInDate..<registrations[indexPath.row].checkOutDate).formatted(date: .numeric, time: .omitted) + ":" + (registrations[indexPath.row].roomType.name)
        
        cell.contentConfiguration = contentConfiguration
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRegistration = registrations[indexPath.row]
        
        let addRegistrationTableViewController = AddEditRegistrationTableViewController(registration: selectedRegistration)
        addRegistrationTableViewController.delegate = self
        let navAddRegistrationTableViewController = UINavigationController(rootViewController: addRegistrationTableViewController)
        
        navigationController?.present(navAddRegistrationTableViewController, animated: true)
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

extension RegistrationTableViewController {
    func style() {
        title = "Registrations"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: registrationCell.reuseIdentifier!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewRegistration(_ :)))
    }
    
    func layout() {
        
    }
}

extension RegistrationTableViewController {
    @objc func addNewRegistration(_ sender: UIBarButtonItem) {
        let addRegistrationTableViewController = AddEditRegistrationTableViewController(registration: nil)
        addRegistrationTableViewController.delegate = self
        let navControllerAddRegistrationTableViewController = UINavigationController(rootViewController: addRegistrationTableViewController)
        navigationController?.present(navControllerAddRegistrationTableViewController, animated: true)
    }
}

extension RegistrationTableViewController: AddEditRegistrationTableViewControllerDelegate {
    func addRegistrationTableViewController(_ controller: AddEditRegistrationTableViewController, didAddOrEdit registration: Registration?) {
        guard let registration = registration else { return }
       
        if let indexPathForSelectedRegistration = tableView.indexPathForSelectedRow {
            registrations[indexPathForSelectedRegistration.row] = registration
        } else {
            registrations.append(registration)
        }
        tableView.reloadData()
    }
    
    
}
// MARK: - Preview provider

@available (iOS 17, *)
#Preview {
    let navController = UINavigationController(rootViewController: RegistrationTableViewController())
    
    return navController
}
