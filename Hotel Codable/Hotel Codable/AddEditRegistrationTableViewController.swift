//
//  AddRegistrationTableViewController.swift
//  Hotel Codable
//
//  Created by Diego Sierra on 29/02/24.
//

import UIKit

protocol AddEditRegistrationTableViewControllerDelegate: AnyObject {
    func addRegistrationTableViewController(_ controller: AddEditRegistrationTableViewController, didAddOrEdit registration: Registration?)
}

class AddEditRegistrationTableViewController: UITableViewController {
    weak var delegate: AddEditRegistrationTableViewControllerDelegate?
    
    let doneBarButton = UIBarButtonItem()
    
    let firstNameCell = UITableViewCell(style: .default, reuseIdentifier: "FirstNameCell")
    let firstNameTextField = UITextField()
    
    let lastNameCell = UITableViewCell(style: .default, reuseIdentifier: "LastNameCell")
    let lastNameTextField = UITextField()
    
    let emailCell = UITableViewCell(style: .default, reuseIdentifier: "EmailCell")
    let emailTextField = UITextField()
    
    let checkInCell = UITableViewCell(style: .value1, reuseIdentifier: "CheckInCell")
    let checkInDateLabel = UILabel()
    let checkInDatePickerCell = UITableViewCell(style: .default, reuseIdentifier: "CheckInDatePickerCell")
    let checkInDatePicker = UIDatePicker()
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    
    let checkOutCell = UITableViewCell(style: .value1, reuseIdentifier: "CheckOutCell")
    let checkOutDateLabel = UILabel()
    let checkOutDatePickerCell = UITableViewCell(style: .default, reuseIdentifier: "CheckOutDatePickerCell")
    let checkOutDatePicker = UIDatePicker()
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    let numberOfAdultsCell = UITableViewCell(style: .default, reuseIdentifier: "NumberOfAdultsCell")
    let adultsLabel = UILabel()
    let numberOfAdultsLabel = UILabel()
    let numberOfAdultsStepper = UIStepper()
    
    let numberOfChildrenCell = UITableViewCell(style: .default, reuseIdentifier: "NumberOfChildrenCell")
    let childrenLabel = UILabel()
    let numberOfChildrenStepper = UIStepper()
    let numberOfChildrenLabel = UILabel()
    
    let wifiCell = UITableViewCell(style: .default, reuseIdentifier: "WifiCell")
    let wifiLabel = UILabel()
    let wifiPrice = UILabel()
    let wifiSwitch = UISwitch()
    
    let roomTypeLabel = UILabel()
    
    let roomTypeSelectionCell = UITableViewCell(style: .value1, reuseIdentifier: "RoomTypeSelectionCell")
    
    let numberOfNightsCell = UITableViewCell(style: .default, reuseIdentifier: "NumberOfNightsCell")
    let numberOfNightsLabel = UILabel()
    let numberOfNightsCountLabel = UILabel()
    let numberOfNightsDateRange = UILabel()
    let numberOfNightsSummaryStackView = UIStackView()
    
    let roomTypeCell = UITableViewCell(style: .default, reuseIdentifier: "RoomTypeCell")
    let roomTypeTitleLabel = UILabel()
    let roomTypeSummaryStackView = UIStackView()
    let roomTypeTotalCostLabel = UILabel()
    let roomTypeTotalDescriptionLabel = UILabel()
    
    let wifiTotalCell = UITableViewCell(style: .default, reuseIdentifier: "WifiCell")
    let wifiTitleTotalLabel = UILabel()
    let wifiTotalSummaryStackView = UIStackView()
    let wifiTotalCostLabel = UILabel()
    let isWifiIncludedLabel = UILabel()
    
    let totalCell = UITableViewCell(style: .default, reuseIdentifier: "TotalCell")
    let totalLabel = UILabel()
    let totalCostLabel = UILabel()
    
    var roomType: RoomType?
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    
    
    var registration: Registration? {
        get {
            guard let roomType = roomType else { return nil }
            
            let firstName = firstNameTextField.text ?? ""
            let lastName = lastNameTextField.text ?? ""
            let email = emailTextField.text ?? ""
            let checkInDate = checkInDatePicker.date
            let checkOutDate = checkOutDatePicker.date
            let numberOfAdults = Int(numberOfAdultsStepper.value)
            let numberOfChildren = Int(numberOfChildrenStepper.value)
            let hasWifi = wifiSwitch.isOn
            
            return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wifi: hasWifi, roomType: roomType)
        }
        
        set {
            self.firstNameTextField.text = newValue?.firstName
            self.lastNameTextField.text = newValue?.lastName
            self.emailTextField.text = newValue?.emailAddress
            self.checkInDatePicker.date = newValue?.checkInDate ?? Date()
            self.checkOutDatePicker.date = newValue?.checkOutDate ?? Date()
            self.numberOfAdultsStepper.value = Double(newValue?.numberOfAdults ?? 0)
            self.wifiSwitch.isOn = newValue?.wifi ?? false
            self.roomType = newValue?.roomType
            
            updateRoomType()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPathForRoomTypeCell = IndexPath(row: 0, section: 4)
        tableView.reloadRows(at: [indexPathForRoomTypeCell], with: .none)
    
    }
    
    init(registration: Registration?) {
        super.init(style: .grouped)
        self.registration = registration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = section
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 4
        default:
            break
        }
        
        return section
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell = firstNameCell
            case 1:
                cell = lastNameCell
            case 2:
                cell = emailCell
            default:
                //                fatalError("Could not create UITableViewCell for IndexPath.row")
                break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                cell = checkInCell
                var contentConfiguration = cell.defaultContentConfiguration()
                contentConfiguration.text = "Check-In Date"
                contentConfiguration.secondaryText = checkInDateLabel.text
                cell.contentConfiguration = contentConfiguration
            case 1:
                cell = checkInDatePickerCell
            case 2:
                cell = checkOutCell
                var contentConfiguration = cell.defaultContentConfiguration()
                contentConfiguration.text = "Check-Out Date"
                contentConfiguration.secondaryText = checkOutDateLabel.text
                cell.contentConfiguration = contentConfiguration
            case 3:
                cell = checkOutDatePickerCell
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell = numberOfAdultsCell
            case 1:
                cell = numberOfChildrenCell
            default:
                break
            }
            
        case 3:
            cell = wifiCell
        case 4:
            cell = roomTypeSelectionCell
            var contentConfiguration = roomTypeSelectionCell.defaultContentConfiguration()
            contentConfiguration.text = "Room Type"
            contentConfiguration.secondaryText = roomTypeLabel.text
            cell.contentConfiguration = contentConfiguration
            
            cell.accessoryType = .disclosureIndicator
        case 5:
            switch indexPath.row {
            case 0:
                cell = numberOfNightsCell
            case 1:
                cell = roomTypeCell
            case 2:
                cell = wifiTotalCell
            case 3:
                cell = totalCell
            default:
                break
            }
        default:
            //            fatalError("Could not create UITableViewCell")
            break
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case checkInDatePickerIndexPath where isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case checkInDatePickerIndexPath:
            return 190
        case checkOutDatePickerIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checkInDateCell = tableView.indexPath(for: checkInCell) ?? IndexPath(row: 0, section: 1)
        let checkOutDateCell = tableView.indexPath(for: checkOutCell) ?? IndexPath(row: 2, section: 1)
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            setCheckInCheckOutPickersVisibility(checkInPicker: checkInDateCell, checkOutPicker: checkOutDateCell, forRow: indexPath)
        case 4:
            let selectRoomTypeTableViewController = SelectRoomTypeTableViewController()
            if let roomType = roomType {
                selectRoomTypeTableViewController.delegate = self
                selectRoomTypeTableViewController.roomType = roomType
                navigationController?.pushViewController(selectRoomTypeTableViewController, animated: true)
            } else {
                selectRoomTypeTableViewController.delegate = self
                selectRoomTypeTableViewController.roomType = nil
                navigationController?.pushViewController(selectRoomTypeTableViewController, animated: true)
            }
        default:
            break
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        if section == 5 {
            title = "CHARGES"
        }
        return title
    }
}

extension AddEditRegistrationTableViewController {
    func style() {
        if let _ = registration {
            title = "Edit Guest Registration"
        } else {
            title = "Add Guest Registration"
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: firstNameCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: lastNameCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: emailCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: checkInCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: checkInDatePickerCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: checkOutCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: checkOutDatePickerCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: numberOfAdultsCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: numberOfChildrenCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: wifiCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: roomTypeSelectionCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: numberOfNightsCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: roomTypeCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: wifiCell.reuseIdentifier!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: totalCell.reuseIdentifier!)
        
        doneBarButton.title = "Done"
        doneBarButton.style = .done
        doneBarButton.target = self
        doneBarButton.action = #selector(doneButtonTapped(_ :))
        navigationItem.rightBarButtonItem = doneBarButton
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_ :)))
        
        firstNameCell.contentView.addSubview(firstNameTextField)
        lastNameCell.contentView.addSubview(lastNameTextField)
        emailCell.contentView.addSubview(emailTextField)
        
        
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.placeholder = "First Name"
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.placeholder = "Last Name"
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkInDateLabel.font = UIFont.systemFont(ofSize: 17)
        
        checkInDatePickerCell.contentView.addSubview(checkInDatePicker)
        checkInDatePicker.preferredDatePickerStyle = .wheels
        checkInDatePicker.translatesAutoresizingMaskIntoConstraints = false
        checkInDatePicker.datePickerMode = .date
        checkInDatePicker.addTarget(self, action: #selector(updateDateViews), for: .valueChanged)
        checkInDatePicker.addTarget(self, action: #selector(updateChargesSection), for: .valueChanged)
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.font = UIFont.systemFont(ofSize: 17)
        
        checkOutDatePickerCell.contentView.addSubview(checkOutDatePicker)
        checkOutDatePicker.preferredDatePickerStyle = .wheels
        checkOutDatePicker.translatesAutoresizingMaskIntoConstraints = false
        checkOutDatePicker.datePickerMode = .date
        checkOutDatePicker.addTarget(self, action: #selector(updateDateViews), for: .valueChanged)
        checkOutDatePicker.addTarget(self, action: #selector(updateChargesSection), for: .valueChanged)
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        numberOfAdultsCell.contentView.addSubview(adultsLabel)
        numberOfAdultsCell.contentView.addSubview(numberOfAdultsStepper)
        numberOfAdultsCell.contentView.addSubview(numberOfAdultsLabel)
        
        adultsLabel.translatesAutoresizingMaskIntoConstraints = false
        adultsLabel.text = "Adults"
        
        numberOfAdultsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfAdultsLabel.text = "0"
        
        numberOfAdultsStepper.translatesAutoresizingMaskIntoConstraints = false
        numberOfAdultsStepper.addTarget(self, action: #selector(updateNumberOfGuests), for: .valueChanged)
        
        numberOfChildrenCell.contentView.addSubview(childrenLabel)
        numberOfChildrenCell.contentView.addSubview(numberOfChildrenLabel)
        numberOfChildrenCell.contentView.addSubview(numberOfChildrenStepper)
        
        childrenLabel.translatesAutoresizingMaskIntoConstraints = false
        childrenLabel.text = "Children"
        
        numberOfChildrenLabel.translatesAutoresizingMaskIntoConstraints
        = false
        numberOfChildrenLabel.text = "0"
        
        numberOfChildrenStepper.translatesAutoresizingMaskIntoConstraints = false
        numberOfChildrenStepper.addTarget(self, action: #selector(updateNumberOfGuests), for: .valueChanged)
        
        wifiCell.contentView.addSubview(wifiLabel)
        wifiCell.contentView.addSubview(wifiPrice)
        wifiCell.contentView.addSubview(wifiSwitch)
        
        wifiLabel.text = "Wi-Fi"
        wifiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        wifiPrice.text = "$10 per day"
        wifiPrice.translatesAutoresizingMaskIntoConstraints = false
        
        wifiSwitch.translatesAutoresizingMaskIntoConstraints = false
        wifiSwitch.addTarget(self, action: #selector(wifiSwitchButtonTapped(_ :)), for: .valueChanged)
        wifiSwitch.addTarget(self, action: #selector(updateChargesSection), for: .valueChanged)
        
        numberOfNightsCell.contentView.addSubview(numberOfNightsLabel)
        numberOfNightsCell.contentView.addSubview(numberOfNightsSummaryStackView)
        
        numberOfNightsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfNightsLabel.text = "Number of Nights"
      
        numberOfNightsSummaryStackView.translatesAutoresizingMaskIntoConstraints = false
        numberOfNightsSummaryStackView.axis = .vertical
        numberOfNightsSummaryStackView.spacing = 5
        numberOfNightsSummaryStackView.addArrangedSubview(numberOfNightsCountLabel)
        numberOfNightsSummaryStackView.addArrangedSubview(numberOfNightsDateRange)
        numberOfNightsSummaryStackView.alignment = .trailing
       
        numberOfNightsDateRange.font = .systemFont(ofSize: 13, weight: .light)
        
        roomTypeCell.contentView.addSubview(roomTypeTitleLabel)
        roomTypeCell.contentView.addSubview(roomTypeSummaryStackView)
        
        roomTypeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        roomTypeTitleLabel.text = "Room Type"
        
        roomTypeSummaryStackView.translatesAutoresizingMaskIntoConstraints = false
        roomTypeSummaryStackView.axis = .vertical
        roomTypeSummaryStackView.alignment = .trailing
        roomTypeSummaryStackView.addArrangedSubview(roomTypeTotalCostLabel)
        roomTypeSummaryStackView.addArrangedSubview(roomTypeTotalDescriptionLabel)
        
        roomTypeTotalDescriptionLabel.font = .systemFont(ofSize: 13, weight: .light)
        
        wifiTotalCell.contentView.addSubview(wifiTitleTotalLabel)
        wifiTotalCell.contentView.addSubview(wifiTotalSummaryStackView)
        
        wifiTitleTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        wifiTitleTotalLabel.text = "Wi-Fi"
        
        wifiTotalSummaryStackView.translatesAutoresizingMaskIntoConstraints = false
        wifiTotalSummaryStackView.axis = .vertical
        wifiTotalSummaryStackView.alignment = .trailing
        wifiTotalSummaryStackView.addArrangedSubview(wifiTotalCostLabel)
        wifiTotalSummaryStackView.addArrangedSubview(isWifiIncludedLabel)
      
        isWifiIncludedLabel.font = .systemFont(ofSize: 15, weight: .light)
        
        totalCell.contentView.addSubview(totalLabel)
        totalCell.contentView.addSubview(totalCostLabel)
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.text = "Total"
        
        totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCostLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        updateChargesSection()
        
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: firstNameCell.contentView.topAnchor, constant: 10),
            firstNameTextField.leadingAnchor.constraint(equalTo: firstNameCell.contentView.leadingAnchor, constant: 10),
            firstNameCell.contentView.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            firstNameCell.contentView.bottomAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameCell.contentView.topAnchor, constant: 10),
            lastNameTextField.leadingAnchor.constraint(equalTo: lastNameCell.contentView.leadingAnchor, constant: 10),
            lastNameCell.contentView.trailingAnchor.constraint(equalTo: lastNameTextField.trailingAnchor),
            lastNameCell.contentView.bottomAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10),
            
            emailTextField.topAnchor.constraint(equalTo: emailCell.contentView.topAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: emailCell.contentView.leadingAnchor, constant: 10),
            emailCell.contentView.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            emailCell.contentView.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            
            checkInDatePicker.topAnchor.constraint(equalTo: checkInDatePickerCell.contentView.topAnchor),
            checkInDatePicker.leadingAnchor.constraint(equalTo: checkInDatePickerCell.contentView.leadingAnchor),
            checkInDatePicker.bottomAnchor.constraint(equalTo: checkInDatePickerCell.contentView.bottomAnchor),
            checkInDatePickerCell.contentView.trailingAnchor.constraint(equalTo: checkInDatePicker.trailingAnchor),
            
            checkOutDatePicker.topAnchor.constraint(equalTo: checkOutDatePickerCell.contentView.topAnchor),
            checkOutDatePicker.leadingAnchor.constraint(equalTo: checkOutDatePickerCell.contentView.leadingAnchor),
            checkOutDatePicker.bottomAnchor.constraint(equalTo: checkOutDatePickerCell.contentView.bottomAnchor),
            checkOutDatePickerCell.contentView.trailingAnchor.constraint(equalTo: checkOutDatePicker.trailingAnchor),
            
            adultsLabel.topAnchor.constraint(equalTo: numberOfAdultsCell.contentView.topAnchor, constant: 10),
            adultsLabel.leadingAnchor.constraint(equalTo: numberOfAdultsCell.contentView.leadingAnchor, constant: 20),
            numberOfAdultsCell.contentView.bottomAnchor.constraint(equalTo: adultsLabel.bottomAnchor, constant: 10),
            
            numberOfAdultsLabel.topAnchor.constraint(equalTo: numberOfAdultsCell.contentView.topAnchor, constant: 10),
            numberOfAdultsCell.contentView.bottomAnchor.constraint(equalTo: numberOfAdultsLabel.bottomAnchor, constant: 15),
            
            numberOfAdultsStepper.topAnchor.constraint(equalTo: numberOfAdultsCell.contentView.topAnchor, constant: 5),
            numberOfAdultsStepper.leadingAnchor.constraint(equalTo: numberOfAdultsLabel.trailingAnchor, constant: 10),
            numberOfAdultsCell.contentView.trailingAnchor.constraint(equalTo: numberOfAdultsStepper.trailingAnchor, constant: 10),
            numberOfAdultsCell.contentView.bottomAnchor.constraint(equalTo: numberOfAdultsStepper.bottomAnchor, constant: 10),
            
            childrenLabel.topAnchor.constraint(equalTo: numberOfChildrenCell.contentView.topAnchor, constant: 10),
            childrenLabel.leadingAnchor.constraint(equalTo: numberOfChildrenCell.contentView.leadingAnchor, constant: 20),
            numberOfChildrenCell.contentView.bottomAnchor.constraint(equalTo: childrenLabel.bottomAnchor, constant: 10),
            
            numberOfChildrenLabel.topAnchor.constraint(equalTo: numberOfChildrenCell.contentView.topAnchor, constant: 10),
            numberOfChildrenCell.contentView.bottomAnchor.constraint(equalTo: numberOfChildrenLabel.bottomAnchor, constant: 15),
            
            numberOfChildrenStepper.topAnchor.constraint(equalTo: numberOfChildrenCell.contentView.topAnchor, constant: 5),
            numberOfChildrenStepper.leadingAnchor.constraint(equalTo: numberOfChildrenLabel.trailingAnchor, constant: 10),
            numberOfChildrenCell.contentView.trailingAnchor.constraint(equalTo: numberOfChildrenStepper.trailingAnchor, constant: 10),
            numberOfChildrenCell.contentView.bottomAnchor.constraint(equalTo: numberOfChildrenStepper.bottomAnchor, constant: 10),
            
            wifiLabel.topAnchor.constraint(equalTo: wifiCell.contentView.topAnchor, constant: 15),
            wifiLabel.leadingAnchor.constraint(equalTo: wifiCell.contentView.leadingAnchor, constant: 20),
            wifiCell.contentView.bottomAnchor.constraint(equalTo: wifiLabel.bottomAnchor, constant: 15),
            
            wifiPrice.topAnchor.constraint(equalTo: wifiCell.contentView.topAnchor, constant: 15),
            wifiSwitch.leadingAnchor.constraint(equalTo: wifiPrice.trailingAnchor, constant: 10),
            
            wifiSwitch.topAnchor.constraint(equalTo: wifiCell.contentView.topAnchor, constant: 10),
            wifiCell.contentView.trailingAnchor.constraint(equalTo: wifiSwitch.trailingAnchor, constant: 10),
            wifiCell.contentView.bottomAnchor.constraint(equalTo: wifiSwitch.bottomAnchor, constant: 10),
            
            numberOfNightsLabel.topAnchor.constraint(equalTo: numberOfNightsCell.contentView.topAnchor, constant: 10),
            numberOfNightsLabel.leadingAnchor.constraint(equalTo: numberOfNightsCell.contentView.leadingAnchor, constant: 20),
            numberOfNightsCell.contentView.bottomAnchor.constraint(equalTo: numberOfNightsLabel.bottomAnchor, constant: 10),
            
            numberOfNightsSummaryStackView.topAnchor.constraint(equalTo: numberOfNightsCell.contentView.topAnchor, constant: 10),
            numberOfNightsCell.contentView.bottomAnchor.constraint(equalTo: numberOfNightsSummaryStackView.bottomAnchor, constant: 10),
            numberOfNightsCell.contentView.trailingAnchor.constraint(equalTo: numberOfNightsSummaryStackView.trailingAnchor, constant: 20),
            
            roomTypeTitleLabel.topAnchor.constraint(equalTo: roomTypeCell.contentView.topAnchor, constant: 10),
            roomTypeTitleLabel.leadingAnchor.constraint(equalTo: roomTypeCell.contentView.leadingAnchor, constant: 20),
            roomTypeCell.contentView.bottomAnchor.constraint(equalTo: roomTypeTitleLabel.bottomAnchor, constant: 10),
            
            roomTypeSummaryStackView.topAnchor.constraint(equalTo: roomTypeCell.contentView.topAnchor, constant: 10),
            roomTypeCell.contentView.trailingAnchor.constraint(equalTo: roomTypeSummaryStackView.trailingAnchor, constant: 20),
            roomTypeCell.contentView.bottomAnchor.constraint(equalTo: roomTypeSummaryStackView.bottomAnchor, constant: 10),
            
            wifiTitleTotalLabel.topAnchor.constraint(equalTo: wifiTotalCell.contentView.topAnchor, constant: 10),
            wifiTitleTotalLabel.leadingAnchor.constraint(equalTo: wifiTotalCell.contentView.leadingAnchor, constant: 20),
            wifiTotalCell.contentView.bottomAnchor.constraint(equalTo: wifiTitleTotalLabel.bottomAnchor, constant: 10),
            
            wifiTotalSummaryStackView.topAnchor.constraint(equalTo: wifiTotalCell.contentView.topAnchor, constant: 10),
            wifiTotalCell.contentView.trailingAnchor.constraint(equalTo: wifiTotalSummaryStackView.trailingAnchor, constant: 20),
            wifiTotalCell.contentView.bottomAnchor.constraint(equalTo: wifiTotalSummaryStackView.bottomAnchor, constant: 10),
            
            totalLabel.topAnchor.constraint(equalTo: totalCell.contentView.topAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: totalCell.contentView.leadingAnchor, constant: 20),
            totalCell.contentView.bottomAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 10),
            
            totalCostLabel.topAnchor.constraint(equalTo: totalCell.contentView.topAnchor, constant: 10),
            totalCell.contentView.trailingAnchor.constraint(equalTo: totalCostLabel.trailingAnchor, constant: 20),
            totalCell.contentView.bottomAnchor.constraint(equalTo: totalCostLabel.bottomAnchor, constant: 10),
        ])
    }
    
}


// MARK: - General methods
extension AddEditRegistrationTableViewController {
    @objc func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        self.checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        self.checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        guard let indexPathForCheckInCell = tableView.indexPath(for: checkInCell) else { return }
        guard let indexPathForCheckOutCell = tableView.indexPath(for: checkOutCell) else { return }
        tableView.reloadRows(at: [indexPathForCheckInCell, indexPathForCheckOutCell], with: .none)
        
    }
    
    @objc func wifiSwitchButtonTapped(_ sender: UISwitch) {
        
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.addRegistrationTableViewController(self, didAddOrEdit: registration)
        navigationController?.dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            doneBarButton.isEnabled = true
        } else {
            roomTypeLabel.text = "Not Set"
            doneBarButton.isEnabled = false
        }
    }
    
    func setCheckInCheckOutPickersVisibility(checkInPicker indexPathForCheckInCell: IndexPath, checkOutPicker indexPathForCheckOutCell: IndexPath, forRow selectedRow: IndexPath) {
        if selectedRow == indexPathForCheckInCell && !isCheckOutDatePickerVisible {
            isCheckInDatePickerVisible.toggle()
        } else if selectedRow == indexPathForCheckOutCell && !isCheckInDatePickerVisible {
            isCheckOutDatePickerVisible.toggle()
        } else if selectedRow == indexPathForCheckInCell || selectedRow == indexPathForCheckOutCell {
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func updateChargesSection() {
        let dateComponents = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date)
        numberOfNightsCountLabel.text = "\((dateComponents.day ?? 0))"
        
        numberOfNightsDateRange.text = "\(checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)) - \(checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted))"
        
        var roomTypeTotalCost = 0
        roomTypeTotalCost = (roomType?.price ?? 0) * (dateComponents.day ?? 0)
        roomTypeTotalCostLabel.text = "$ \(roomTypeTotalCost)"
        
        roomTypeTotalDescriptionLabel.text = "\(roomType?.name ?? "No Selection") @ $\(roomType?.price ?? 0)/night"
        
        var wifiTotalCost = 0
        if wifiSwitch.isOn {
            wifiTotalCost = (10) * (dateComponents.day ?? 0)
            wifiTotalCostLabel.text = "$ \(wifiTotalCost)"
            isWifiIncludedLabel.text = "Yes"
        } else {
            wifiTotalCostLabel.text = "$ \(wifiTotalCost)"
            isWifiIncludedLabel.text = "No"
        }
        
        totalCostLabel.text = "$ \(roomTypeTotalCost + wifiTotalCost)"
    }
}


// MARK: - Protocol conformances.
extension AddEditRegistrationTableViewController: SelectRoomTypeTableViewControllerDelegate {
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateChargesSection()
        updateRoomType()
    }
    
}


@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: AddEditRegistrationTableViewController(registration: nil))
}
