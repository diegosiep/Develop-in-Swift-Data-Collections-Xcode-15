//
//  TableViewController.swift
//  EmojiDictionary
//
//  Created by Diego Sierra on 13/02/24.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    var emojis = Emoji.defaultData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return emojis[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let emoji = emojis[section].first else { return nil }
     
        return emoji.section.rawValue
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emojis = emojis[indexPath.section][indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = "\(emojis.symbol) - \(emojis.name)"
        contentConfiguration.secondaryText = emojis.description
        cell.contentConfiguration = contentConfiguration
        cell.showsReorderControl = true
        
        return cell
    }
    
    //    MARK: Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.section][indexPath.row]
        print("\(emoji.symbol) - \(emoji.name)")
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = emojis[fromIndexPath.section].remove(at: fromIndexPath.row)
        emojis[to.section].insert(movedEmoji, at: to.row)
        tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
}

//    MARK: layout and style methods.

extension EmojiTableViewController {
    
    func style() {
        title = "Emoji Dictionary"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmojiCell")
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    func layout() {
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
}

// MARK: Preview provider
@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: EmojiTableViewController(style: .insetGrouped))
    
}
