//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Diego Sierra on 23/03/24.
//

import UIKit
import MessageUI


protocol ToDoDetailTableViewControllerDelegate: AnyObject {
    func didSaveToDo(_ controller: ToDoDetailTableViewController, toDo: ToDo)
}

class ToDoDetailTableViewController: UITableViewController {
    weak var delegate: ToDoDetailTableViewControllerDelegate?
    var toDo: ToDo?
    
    var saveBarButton: UIBarButtonItem!
    var cancelBarButton: UIBarButtonItem!
    
    var basicInformationCell: UITableViewCell!
    let basicInfoCellReuseIdentifier = "BasicInformationCell"
    var basicInfoStackView: UIStackView!
    var toDoTitleTextField: UITextField!
    var isCompleteButton: UIButton!
    
    var dueDateCell: UITableViewCell!
    let dueDateCellReuseIdentifier = "DueDateCellReuseIdentifier"
    
    var dueDateDatePickerCell: UITableViewCell!
    let dueDateDatePickerCellReuseIdentifier = "DueDateDatePickerReuseIdentifier"
    var dueDateDatePicker: UIDatePicker!
    var isDatePickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    var notesCell: UITableViewCell!
    let notesCellReuseIdentifier = "NotesCellReuseIdentifier"
    var notesCellTextView: UITextView!
    
    var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            fatalError("Incorrect number of sections")
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return basicInformationCell
        case 1:
            switch indexPath.row {
            case 0:
                updateDueDateLabel(self.dueDateDatePicker)
                return dueDateCell
            case 1:
                return dueDateDatePickerCell
            default:
                fatalError("Could not create UITableViewCell")
            }
        case 2:
            return notesCell
        default:
            fatalError("Could not create UITableViewCell")
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basic Information"
        case 2:
            return "Notes"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
            
        }
    }
    
    
}

// MARK: - Style and layout methods

extension ToDoDetailTableViewController {
    private func style() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton(_ :)))
        navigationItem.rightBarButtonItem = saveBarButton
        
        cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton(_ :)))
        navigationItem.leftBarButtonItem = cancelBarButton
        
        basicInformationCell = UITableViewCell(style: .default, reuseIdentifier: basicInfoCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: basicInfoCellReuseIdentifier)
        
        toDoTitleTextField = UITextField()
        toDoTitleTextField.borderStyle = .roundedRect
        toDoTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        toDoTitleTextField.placeholder = "Remind me to..."
        toDoTitleTextField.addTarget(self, action: #selector(textEditingChanged(_ :)), for: .editingChanged)
        toDoTitleTextField.addTarget(self, action: #selector(returnPressed(_ :)), for: .primaryActionTriggered)
        
        isCompleteButton = UIButton()
        isCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        isCompleteButton.addTarget(self, action: #selector(completedToDoAction(_ :)), for: .primaryActionTriggered)
        isCompleteButton.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)
        isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
        isCompleteButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        
        
        basicInfoStackView = UIStackView(arrangedSubviews: [isCompleteButton, toDoTitleTextField])
        basicInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        basicInfoStackView.axis = .horizontal
        basicInfoStackView.distribution = .fill
        basicInfoStackView.spacing = 10
        basicInformationCell.contentView.addSubview(basicInfoStackView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: dueDateCellReuseIdentifier)
        dueDateCell = UITableViewCell(style: .value1, reuseIdentifier: dueDateCellReuseIdentifier)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: dueDateDatePickerCellReuseIdentifier)
        dueDateDatePickerCell = UITableViewCell(style: .default, reuseIdentifier: dueDateDatePickerCellReuseIdentifier)
        
        dueDateDatePicker = UIDatePicker()
        dueDateDatePicker.date = Date().addingTimeInterval(24 * 60 * 60)
        dueDateDatePicker.translatesAutoresizingMaskIntoConstraints = false
        dueDateDatePicker.preferredDatePickerStyle = .wheels
        dueDateDatePicker.datePickerMode = .date
        dueDateDatePickerCell.contentView.addSubview(dueDateDatePicker)
        dueDateDatePicker.addTarget(self, action: #selector(updateDueDateLabel(_ :)), for: .valueChanged)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: notesCellReuseIdentifier)
        notesCell = UITableViewCell(style: .default, reuseIdentifier: notesCellReuseIdentifier)
        
        notesCellTextView = UITextView()
        notesCellTextView.translatesAutoresizingMaskIntoConstraints = false
        notesCellTextView.textAlignment = .justified
        
        notesCell.contentView.addSubview(notesCellTextView)
        
        shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareToDo(_ :)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems([flexButton ,shareButton], animated: true)
        
        navigationController?.isToolbarHidden = false
        
        updateSaveButton()
        
        if let toDo = toDo {
            title = "Edit To-Do"
            isCompleteButton.isSelected = toDo.isComplete
            toDoTitleTextField.text = toDo.title
            dueDateDatePicker.date = toDo.dueDate
            notesCellTextView.text = toDo.notes
            updateSaveButton()
        } else {
            title = "New To-Do"
        }
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            basicInfoStackView.topAnchor.constraint(equalTo: basicInformationCell.contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            basicInfoStackView.leadingAnchor.constraint(equalTo: basicInformationCell.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            basicInformationCell.contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: basicInfoStackView.trailingAnchor, constant: 10),
            basicInformationCell.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: basicInfoStackView.bottomAnchor, constant: 10),
            
            dueDateDatePicker.topAnchor.constraint(equalTo: dueDateDatePickerCell.contentView.topAnchor),
            dueDateDatePicker.leadingAnchor.constraint(equalTo: dueDateDatePickerCell.contentView.leadingAnchor),
            dueDateDatePickerCell.contentView.trailingAnchor.constraint(equalTo: dueDateDatePicker.trailingAnchor),
            dueDateDatePickerCell.contentView.bottomAnchor.constraint(equalTo: dueDateDatePicker.bottomAnchor),
            
            notesCellTextView.topAnchor.constraint(equalTo: notesCell.contentView.topAnchor, constant: 10),
            notesCellTextView.leadingAnchor.constraint(equalTo: notesCell.contentView.leadingAnchor, constant: 10),
            notesCell.contentView.bottomAnchor.constraint(equalTo: notesCellTextView.bottomAnchor, constant: 10),
            notesCell.contentView.trailingAnchor.constraint(equalTo: notesCellTextView.trailingAnchor, constant: 10),
            
            
        ])
        
        isCompleteButton.setContentHuggingPriority(.init(750), for: .horizontal)
        
    }
}

// MARK: - General methods

extension ToDoDetailTableViewController {
    
    func updateSaveButton() {
        let shouldEnableSaveButton = toDoTitleTextField.text?.isEmpty == false
        saveBarButton.isEnabled = shouldEnableSaveButton
        
    }
    
    @objc func saveButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            let title = self.toDoTitleTextField.text!
            let isComplete = self.isCompleteButton.isSelected
            let dueDate = self.dueDateDatePicker.date
            let notes = self.notesCellTextView.text
            
            self.toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
            guard let toDo = self.toDo else { return }
            self.delegate?.didSaveToDo(self, toDo: toDo)
            
            
        }
    }
    
    @objc func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func completedToDoAction(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateSaveButton()
        
    }
    
    @objc func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @objc func updateDueDateLabel(_ sender: UIDatePicker) {
        var contentConfiguration = dueDateCell.defaultContentConfiguration()
        contentConfiguration.text = "Due Date"
        contentConfiguration.secondaryText = sender.date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
        dueDateCell.contentConfiguration = contentConfiguration
    }
    
    @objc func shareToDo(_ sender: UIBarButtonItem) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["example@example.com"])
        mailComposer.setSubject("Shared To-Do Details: \(toDo?.title ?? "No title")")
        mailComposer.setMessageBody("These are the details for \(toDo?.title ?? "this") To-Do: To-Do name: \(toDo?.title ?? "To-Do"), Completion: \(toDo?.isComplete ?? false), Due Date: \(toDo?.dueDate.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted)), Notes: \(toDo?.notes ?? "No notes")", isHTML: false)
        
        present(mailComposer, animated: true, completion: nil)
        
        
    }
}

// MARK: - Protocol conformances

extension ToDoDetailTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        dismiss(animated: true)
    }
}

// MARK: - Preview Provider

@available (iOS 17, *)
#Preview {
    let toDoDetailTableViewController = ToDoDetailTableViewController(style: .grouped)
    let navController = UINavigationController(rootViewController: toDoDetailTableViewController)
    
    return navController
    
}
