//
//  AthleteFormViewController.swift
//  FavoriteAthlete
//
//  Created by Diego Sierra on 10/02/24.
//

import UIKit

class AthleteFormViewController: UIViewController {
    var athlete: Athlete?
    var indexPathForSelectedAthlete: IndexPath?
    
    let label = UILabel()
    let stackView = UIStackView()
    
    let nameTextField = UITextField()
    let ageTextField = UITextField()
    let leagueTextField = UITextField()
    let teamTextField = UITextField()
    
    let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        updateView()
        
    }
    
    init(athlete: Athlete?, indexPathForSelectedAthlete: IndexPath?) {
        super.init(nibName: nil, bundle: nil)
        self.athlete = athlete
        self.indexPathForSelectedAthlete = indexPathForSelectedAthlete
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AthleteFormViewController {
    //    MARK: General methods
    
    func updateView() {
        guard let athlete = athlete else { return }
        nameTextField.text = athlete.name
        ageTextField.text = "\(athlete.age)"
        leagueTextField.text = athlete.league
        teamTextField.text = athlete.team
    }
    
    @objc func saveAthlete() {
        guard let name = nameTextField.text, let ageString = ageTextField.text, let age = Int(ageString), let league = leagueTextField.text, let team = teamTextField.text else { return }
        athlete = Athlete(name: name, age: age, league: league, team: team)
        let athleteTableViewController = navigationController?.viewControllers[0] as! AthleteTableViewController
        
        if let athlete = athlete {
            if let indexPathForSelectedRow = indexPathForSelectedAthlete {
                athleteTableViewController.athletes[indexPathForSelectedRow.row] = athlete
                navigationController?.popToRootViewController(animated: true)
            } else {
                athleteTableViewController.athletes.append(athlete)
                navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
}

extension AthleteFormViewController {
    
    func style() {
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(stackView)
        view.addSubview(saveButton)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(ageTextField)
        stackView.addArrangedSubview(leagueTextField)
        stackView.addArrangedSubview(teamTextField)
        
        label.text = "Who is your favorite athlete?"
        label.textAlignment = .center
        
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        
        ageTextField.placeholder = "Age"
        ageTextField.borderStyle = .roundedRect
        ageTextField.keyboardType = .numberPad
        
        leagueTextField.placeholder = "League"
        leagueTextField.borderStyle = .roundedRect
        
        teamTextField.placeholder = "Team"
        teamTextField.borderStyle = .roundedRect
        
        saveButton.setTitle("Save", for: [])
        saveButton.configuration = .plain()
        saveButton.addTarget(self, action: #selector(saveAthlete), for: .primaryActionTriggered)
        
    }
    
    func layout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        leagueTextField.translatesAutoresizingMaskIntoConstraints = false
        teamTextField.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 53),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            ageTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            leagueTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            teamTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            leagueTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            teamTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            saveButton.topAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
}


