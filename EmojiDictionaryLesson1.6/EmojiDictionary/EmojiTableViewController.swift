//
//  TableViewController.swift
//  EmojiDictionary
//
//  Created by Diego Sierra on 13/02/24.
//

import UIKit


class EmojiTableViewController: UITableViewController {
    
    var emojis = Emoji.defaultData
    let addEmojiBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"))
    var addEditEmojiTableViewController: AddEditEmojiTableViewController?
    var emojisBySection = [Section: [Emoji]]() {
        willSet {
            emojisSections = [Section](newValue.keys).sorted()
        }
    }
    
    var emojisSections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configureEmojisBySection()
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return emojisBySection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let emojiSection = emojisSections[section]
        let emojisInSection = emojisBySection[emojiSection] ?? []
        return emojisInSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return emojisSections[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emojiSection = emojisSections[indexPath.section]
        let emoji = emojisBySection[emojiSection]?[indexPath.row]
        
        guard let emojiToDeque = emoji else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: EmojiTableViewCell.reuseIdentifier, for: indexPath) as! EmojiTableViewCell
        cell.configureCell(with: emojiToDeque)
        cell.showsReorderControl = true
        
        return cell
    }
    
    //    MARK: Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emojiSection = emojisSections[indexPath.section]
        let emoji = emojisBySection[emojiSection]?[indexPath.row]
        addEditEmojiTableViewController = AddEditEmojiTableViewController(emoji: emoji)
        guard let addEditEmojiTableViewController = addEditEmojiTableViewController else { return }
        addEditEmojiTableViewController.delegate = self
        let navigationViewControllerAddEditEmojiTableViewController = UINavigationController(rootViewController: addEditEmojiTableViewController)
        
        present(navigationViewControllerAddEditEmojiTableViewController, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let emojiSectionToMoveFrom = emojisSections[fromIndexPath.section]
        var movedEmoji = emojisBySection[emojiSectionToMoveFrom]?.remove(at: fromIndexPath.row)
        let emojiSectionToMoveTo = emojisSections[to.section]
        movedEmoji?.section = emojiSectionToMoveTo
        guard let movedEmoji = movedEmoji else { return }
        emojisBySection[emojiSectionToMoveTo]?.insert(movedEmoji, at: to.row)
        if let emojiSectionToUpdate = emojisBySection[emojiSectionToMoveFrom], emojiSectionToUpdate.isEmpty {
            emojisBySection.removeValue(forKey: emojiSectionToMoveFrom)
        }
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let emojiSection = emojisSections[indexPath.section]
            emojisBySection[emojiSection]?.remove(at: indexPath.row)
            if let emojiSectionToUpdate = emojisBySection[emojiSection], emojiSectionToUpdate.isEmpty {
                emojisBySection.removeValue(forKey: emojiSection)
            }
            tableView.reloadData()
        }
    }
    
   
    
}

// MARK: General methods
extension EmojiTableViewController {
    @objc func addEmojiAction() {
        let addEditEmojiTableViewController = AddEditEmojiTableViewController(emoji: nil)
        addEditEmojiTableViewController.delegate = self
        let navigationControllerForAddEditEmojiTableViewController = UINavigationController(rootViewController: addEditEmojiTableViewController)
        present(navigationControllerForAddEditEmojiTableViewController, animated: true)
    }
    
    func configureEmojisBySection() {
        emojisBySection = emojis.reduce(into: [Section: [Emoji]]()) { partialResult, emoji in
            let section: Section
            section = emoji.section
            
            partialResult[section, default: []].append(emoji)
        }
        
    }
    
    func checkIfSectionIsEmpty(for section: Section) {
        if let emojiSectionToUpdate = emojisBySection[section], emojiSectionToUpdate.isEmpty {
            emojisBySection.removeValue(forKey: section)
        }
    }
}

//    MARK: layout and style methods.

extension EmojiTableViewController {
    func style() {
        title = "Emoji Dictionary"
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: EmojiTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = addEmojiBarButtonItem
        
        addEmojiBarButtonItem.target = self
        addEmojiBarButtonItem.action = #selector(addEmojiAction)
        
    }
    
    func layout() {
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
}

//MARK: Conformance to protocols
extension EmojiTableViewController: AddEditEmojiTableViewControllerDelegate {
    func didEditOrAddEmoji(emoji: Emoji) {
        if let selectedEmojiIndexPath = tableView.indexPathForSelectedRow {
            let selectedEmoji = emojisBySection[emojisSections[selectedEmojiIndexPath.section]]?[selectedEmojiIndexPath.row]
            guard let selectedEmoji = selectedEmoji else { return }
            if emoji.section == selectedEmoji.section {
                emojisBySection[emojisSections[selectedEmojiIndexPath.section]]?[selectedEmojiIndexPath.row] = emoji
                tableView.reloadRows(at: [selectedEmojiIndexPath], with: .automatic)
            } else {
                if let _ = emojisBySection[emoji.section] {
                    emojisBySection[selectedEmoji.section]?.remove(at: selectedEmojiIndexPath.row)
                    emojisBySection[emoji.section]!.append(emoji)
                    checkIfSectionIsEmpty(for: selectedEmoji.section)
                    tableView.reloadData()
                } else {
                    emojisBySection[selectedEmoji.section]?.remove(at: selectedEmojiIndexPath.row)
                    checkIfSectionIsEmpty(for: selectedEmoji.section)
                    emojisBySection.updateValue([emoji], forKey: emoji.section)
                    tableView.reloadData()
                }
            }
        } else {
            if let _ = emojisBySection[emoji.section] {
                emojisBySection[emoji.section]!.append(emoji)
                tableView.reloadData()
            } else {
                emojisBySection.updateValue([emoji], forKey: emoji.section)
                tableView.reloadData()
            }
            tableView.reloadData()
        }
    }
}

// MARK: Preview provider
@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: EmojiTableViewController(style: .insetGrouped))
    
}
