//
//  SelectRoomTypeTableViewController.swift
//  Hotel Codable
//
//  Created by Diego Sierra on 03/03/24.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate: AnyObject {
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    let roomTypeCell = UITableViewCell(style: .value1, reuseIdentifier: "RoomTypeCell")
    var roomType: RoomType?
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
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
        return RoomType.all.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: roomTypeCell.reuseIdentifier!, for: indexPath)
        
        let roomToDeque = RoomType.all[indexPath.row]
        var configuration = roomTypeCell.defaultContentConfiguration()
        configuration.text = roomToDeque.name
        configuration.secondaryText = "$ \(roomToDeque.price)"
        
        cell.contentConfiguration = configuration
        
        if roomToDeque == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let roomType = RoomType.all[indexPath.row]
        self.roomType = roomType

        delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
        tableView.reloadData()
    }
    
}

extension SelectRoomTypeTableViewController {
    func style() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: roomTypeCell.reuseIdentifier!)
        
    }
    
    func layout() {
        
    }
}

@available (iOS 17, *)
#Preview {
    let navController = UINavigationController(rootViewController: SelectRoomTypeTableViewController())
    return navController
}
