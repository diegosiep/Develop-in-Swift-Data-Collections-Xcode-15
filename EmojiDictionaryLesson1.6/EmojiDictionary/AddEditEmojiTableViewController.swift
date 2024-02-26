//
//  AddEditEmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Diego Sierra on 16/02/24.
//

import UIKit

protocol AddEditEmojiTableViewControllerDelegate {
    func didEditOrAddEmoji(emoji: Emoji)
}

class AddEditEmojiTableViewController: UITableViewController {
    var emoji: Emoji?
    var delegate: AddEditEmojiTableViewControllerDelegate?
    let doneButton = UIBarButtonItem()
    let symbolCell = AddEditEmojiTableViewCell()
    let nameCell = AddEditEmojiTableViewCell()
    let descriptionCell = AddEditEmojiTableViewCell()
    let usageCell = AddEditEmojiTableViewCell()
    let sectionTypePickerCell = AddEditEmojiTableViewCell(isSectionTypePicker: true)
    
    init(emoji: Emoji?) {
        super.init(nibName: nil, bundle: nil)
        self.emoji = emoji
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleForTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDoneButton()
    }
    
}

// MARK: UITableView delegate and data source methods.
extension AddEditEmojiTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: AddEditEmojiTableViewCell.reuseIdentifier, for: indexPath) as! AddEditEmojiTableViewCell
        if let emoji = emoji {
            switch indexPath.section {
            case 0:
                cell = symbolCell
                cell.configureTextField(with: emoji.symbol)
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 1:
                cell = nameCell
                cell.configureTextField(with: emoji.name)
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 2:
                cell = descriptionCell
                cell.configureTextField(with: emoji.description)
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 3:
                cell = usageCell
                cell.configureTextField(with: emoji.usage)
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 4:
                cell = sectionTypePickerCell
                cell.configureSectionTypePicker(with: emoji)
            default:
                fatalError("Failed to create UITableViewCell")
            }
            title = "Edit Emoji"
        } else {
            switch indexPath.section {
            case 0:
                cell = symbolCell
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 1:
                cell = nameCell
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 2:
                cell = descriptionCell
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 3:
                cell = usageCell
                cell.textField.addTarget(self, action: #selector(textEditingDidChange), for: .editingChanged)
            case 4:
                cell = sectionTypePickerCell
            default:
                fatalError("Failed to create UITableViewCell")
            }
            title = "Add Emoji"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerText = String()
        switch section {
        case 0:
            headerText = "SYMBOL"
        case 1:
            headerText = "NAME"
        case 2:
            headerText = "DESCRIPTION"
        case 3:
            headerText = "USAGE"
        case 4:
            headerText = "SECTION"
        default:
            break
        }
        return headerText
    }
    
}


// MARK: setup TableView

extension AddEditEmojiTableViewController {
    func setStyleForTableView() {
        doneButton.title = "Done"
        doneButton.target = self
        doneButton.action = #selector(doneButtonAction)
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
        tableView.register(AddEditEmojiTableViewCell.self, forCellReuseIdentifier: AddEditEmojiTableViewCell.reuseIdentifier)
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "TableViewBackgroundColor")!)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        
        
        
    }
}

// MARK: General methods
extension AddEditEmojiTableViewController {
    @objc func doneButtonAction() {
        let selectedEmojiSectionTypeIndex = sectionTypePickerCell.sectionTypePicker.selectedRow(inComponent: 0)
        let emoji = Emoji(symbol: symbolCell.textField.text ?? "", name: nameCell.textField.text ?? "", description: descriptionCell.textField.text ?? "", usage: usageCell.textField.text ?? "", section: Section.allCases.sorted()[selectedEmojiSectionTypeIndex])
        
        delegate?.didEditOrAddEmoji(emoji: emoji)
        
        dismiss(animated: true)
    }
    
    @objc func cancelButton() {
        dismiss(animated: true)
    }
    
    @objc func textEditingDidChange() {
        updateDoneButton()
    }
    
    
    func updateDoneButton() {
        let nameCell = nameCell.textField.text ?? ""
        let descriptionCell = descriptionCell.textField.text ?? ""
        let usageCell = usageCell.textField.text ?? ""
        
        doneButton.isEnabled = containsSingleEmoji(symbolCell.textField) && !nameCell.isEmpty && !descriptionCell.isEmpty && !usageCell.isEmpty
        
    }
    
    func containsSingleEmoji(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count == 1 else { return false }
        let isCombinedIntoEmoji = text.unicodeScalars.count > 1 && text.unicodeScalars.first?.properties.isEmoji ?? false
        let isEmojiPresentation = text.unicodeScalars.first?.properties.isEmojiPresentation ?? false
        
        return isEmojiPresentation || isCombinedIntoEmoji
    }
}



// MARK: Preview Provider
@available (iOS 17, *)
#Preview {
    let tableView = AddEditEmojiTableViewController(emoji: Emoji(symbol: "😃", name: "Happy face", description: "Happy mood", usage: "Happy Mood", section: .smileysAndPeople))
    let navigationController = UINavigationController(rootViewController: tableView)
    return navigationController
    
}
