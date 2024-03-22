
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate {
    let nameCell = UITableViewCell(style: .default, reuseIdentifier: "NameCell")
    var nameCellStackView: UIStackView!
    var nameTextField: UITextField!
    var nameLabel: UILabel!
    
    let dateOfBirthCell = UITableViewCell(style: .default, reuseIdentifier: "DateOfBirth")
    var dobStackView: UIStackView!
    var dobLabel: UILabel!
    var enterDOBLabel: UILabel!
    
    let employeeBirthdayCell = UITableViewCell(style: .default, reuseIdentifier: "BirthdayCell")
    let employeeBirthdayDatePicker = UIDatePicker()
    
    var isEditingBirthday: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
    }
    
    let employeeTypeCell = UITableViewCell(style: .default, reuseIdentifier: "EmployeeTypeCell")
    var employeeTypeLabel: UILabel!
    var selectEmployeeTypeLabel: UILabel!
    
    var employeeType: EmployeeType?
    
    var saveBarButtonItem: UIBarButtonItem!
    
    var cancelBarButtonItem: UIBarButtonItem!
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updateSaveButtonState()
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - TableView data source and delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch section {
        case 0:
            numberOfRows = 3
        case 1:
            numberOfRows = 1
        default:
            break
        }
        
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell = nameCell
            case 1:
                cell = dateOfBirthCell
            case 2:
                cell = employeeBirthdayCell
            default:
                break
            }
        case 1:
            cell = employeeTypeCell
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let indexPathForDatePicker = IndexPath(row: 2, section: 0)
        switch indexPath {
        case indexPathForDatePicker where isEditingBirthday == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let indexPathForDatePicker = IndexPath(row: 2, section: 0)
        
        switch indexPath {
        case indexPathForDatePicker:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == tableView.indexPath(for: dateOfBirthCell) {
            isEditingBirthday.toggle()
        } else if indexPath == tableView.indexPath(for: employeeTypeCell) {
            let employeeTypeTableViewController = EmployeeTypeTableViewController(style: .grouped)
            employeeTypeTableViewController.delegate = self
            employeeTypeTableViewController.employeeType = employeeType
            navigationController?.pushViewController(employeeTypeTableViewController, animated: true)
        }
    }
}


// MARK: - General Methods

extension EmployeeDetailTableViewController {
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            enterDOBLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            enterDOBLabel.textColor = .label
            selectEmployeeTypeLabel.text = employee.employeeType.description
            selectEmployeeTypeLabel.textColor = .label
            employeeType = employee.employeeType
        } else {
            enterDOBLabel.text = "Enter employee's date of birth"
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        saveBarButtonItem.isEnabled = shouldEnableSaveButton && employeeType != nil
    }
    
    @objc func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        guard let employeeType = employeeType else {
            return
        }
        

        let employee = Employee(name: name, dateOfBirth: employeeBirthdayDatePicker.date, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.employee = nil
        }
    }
    
    @objc func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
}

// MARK: - Style and Layout methods

extension EmployeeDetailTableViewController {
    private func style() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: nameCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: dateOfBirthCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeTypeCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: employeeBirthdayCell.reuseIdentifier!)
        
        saveBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped(_ :)))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped(_ :)))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        nameLabel = UILabel()
        nameLabel.text = "Name:"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.borderStyle = .roundedRect
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_ :)), for: .editingChanged)
        
        nameCellStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        nameCellStackView.translatesAutoresizingMaskIntoConstraints = false
        nameCellStackView.axis = .horizontal
        nameCellStackView.distribution = .fill
        nameCellStackView.spacing = 10
        
        nameCell.contentView.addSubview(nameCellStackView)
        
        dobLabel = UILabel()
        dobLabel.text = "Date of birth:"
        
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        
        enterDOBLabel = UILabel()
        enterDOBLabel.text = employeeBirthdayDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        enterDOBLabel.font = .systemFont(ofSize: 15, weight: .ultraLight)
        enterDOBLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dobStackView = UIStackView(arrangedSubviews: [dobLabel, enterDOBLabel])
        dobStackView.translatesAutoresizingMaskIntoConstraints = false
        dobStackView.axis = .horizontal
        dobStackView.distribution = .equalSpacing
        
        dateOfBirthCell.contentView.addSubview(dobStackView)
        
        employeeBirthdayDatePicker.translatesAutoresizingMaskIntoConstraints = false
        employeeBirthdayDatePicker.preferredDatePickerStyle = .wheels
        employeeBirthdayDatePicker.datePickerMode = .date
        let minimumYearBorn = Calendar.current.component(.year, from: Date()) - 65
        let maximumYearBorn = Calendar.current.component(.year, from: Date()) - 16
        let dateComponentsForMinimumYearBorn = DateComponents(calendar: Calendar.current, year: minimumYearBorn)
        let dateComponentsForMaximumYearBorn = DateComponents(calendar: Calendar.current, year: maximumYearBorn, month: 12, day: 31)
        
        let dateComponentsForDefaultSelectedDatePickerDate = DateComponents(calendar: Calendar.current, year: maximumYearBorn)
        
        if let employee = employee {
            employeeBirthdayDatePicker.setDate(employee.dateOfBirth, animated: true)
        } else {
            employeeBirthdayDatePicker.setDate(dateComponentsForDefaultSelectedDatePickerDate.date ?? Date(), animated: true)
        }
        employeeBirthdayDatePicker.minimumDate = dateComponentsForMinimumYearBorn.date
        employeeBirthdayDatePicker.maximumDate = dateComponentsForMaximumYearBorn.date
        employeeBirthdayDatePicker.addTarget(self, action: #selector(employeeBirthdayDatePickerDidChange(_ :)), for: .valueChanged)
    
        
        employeeBirthdayCell.contentView.addSubview(employeeBirthdayDatePicker)
        
        employeeTypeLabel = UILabel()
        employeeTypeLabel.text = "Employee Type:"
        employeeTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectEmployeeTypeLabel = UILabel()
        selectEmployeeTypeLabel.text = "Please select employee type"
        selectEmployeeTypeLabel.font = .systemFont(ofSize: 13, weight: .ultraLight)
        selectEmployeeTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        employeeTypeCell.contentView.addSubview(employeeTypeLabel)
        employeeTypeCell.contentView.addSubview(selectEmployeeTypeLabel)
        
        updateView()
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            nameCellStackView.topAnchor.constraint(equalTo: nameCell.contentView.topAnchor, constant: 10),
            nameCellStackView.leadingAnchor.constraint(equalTo: nameCell.contentView.leadingAnchor, constant: 20),
            nameCell.contentView.bottomAnchor.constraint(equalTo: nameCellStackView.bottomAnchor, constant: 10),
            nameCell.contentView.trailingAnchor.constraint(equalTo: nameCellStackView.trailingAnchor, constant: 20),
            
            dobStackView.topAnchor.constraint(equalTo: dateOfBirthCell.contentView.topAnchor, constant: 10),
            dobStackView.leadingAnchor.constraint(equalTo: dateOfBirthCell.contentView.leadingAnchor, constant: 20),
            dateOfBirthCell.contentView.trailingAnchor.constraint(equalTo: dobStackView.trailingAnchor, constant: 20),
            dateOfBirthCell.contentView.bottomAnchor.constraint(equalTo: dobStackView.bottomAnchor, constant: 10),
            
            employeeBirthdayDatePicker.topAnchor.constraint(equalTo: employeeBirthdayCell.contentView.topAnchor),
            employeeBirthdayDatePicker.leadingAnchor.constraint(equalTo: employeeBirthdayCell.contentView.leadingAnchor),
            employeeBirthdayCell.contentView.trailingAnchor.constraint(equalTo: employeeBirthdayDatePicker.trailingAnchor),
            employeeBirthdayCell.contentView.bottomAnchor.constraint(equalTo: employeeBirthdayDatePicker.bottomAnchor),
            
            employeeTypeLabel.topAnchor.constraint(equalTo: employeeTypeCell.contentView.topAnchor, constant: 15),
            employeeTypeLabel.leadingAnchor.constraint(equalTo: employeeTypeCell.contentView.leadingAnchor, constant: 20),
            employeeTypeCell.contentView.bottomAnchor.constraint(equalTo: employeeTypeLabel.bottomAnchor, constant: 15),
            
            selectEmployeeTypeLabel.topAnchor.constraint(equalTo: employeeTypeCell.contentView.topAnchor, constant: 15),
            selectEmployeeTypeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: employeeTypeLabel.trailingAnchor, constant: 30),
            employeeTypeCell.contentView.trailingAnchor.constraint(equalTo: selectEmployeeTypeLabel.trailingAnchor, constant: 10),
            employeeTypeCell.contentView.bottomAnchor.constraint(equalTo: selectEmployeeTypeLabel.bottomAnchor, constant: 15)
        ])
        
        nameLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        
    }
}

// MARK: - General methods

extension EmployeeDetailTableViewController {
    @objc func employeeBirthdayDatePickerDidChange(_ sender: UIDatePicker) {
        enterDOBLabel.text = sender.date.formatted(date: .abbreviated, time: .omitted)
    }

}

// MARK: - Protocol conformances

extension EmployeeDetailTableViewController: EmployeeTypeTableViewControllerDelegate {
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType?) {
        guard let employeeType = employeeType else { return }
        self.employeeType = employeeType
        self.employee?.employeeType = employeeType
        selectEmployeeTypeLabel.text = employeeType.description
        selectEmployeeTypeLabel.textColor = .black
        updateSaveButtonState()
    }
    
    
}


// MARK: - Preview Provider
@available (iOS 17, *)
#Preview {
    let employeeDetailTableViewController = EmployeeDetailTableViewController(style: .grouped)
    return UINavigationController(rootViewController: employeeDetailTableViewController)
}
