import UIKit


class AthleteTableViewController: UITableViewController {
    let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"))
    
    struct PropertyKeys {
        static let athleteCell = "AthleteCell"
    }
    
    var athletes: [Athlete] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        style()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PropertyKeys.athleteCell)
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athletes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.athleteCell, for: indexPath)
        let athlete = athletes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = athlete.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    //    MARK: Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let athleteToEdit = athletes[indexPath.row]
        navigationController?.pushViewController(AthleteFormViewController(athlete: athleteToEdit, indexPathForSelectedAthlete: indexPath), animated: true)
       
    }
    
}


// MARK: General methods
extension AthleteTableViewController {
    @objc func addAthlete() {
        navigationController?.pushViewController(AthleteFormViewController(athlete: nil, indexPathForSelectedAthlete: nil), animated: true)
    }
    
}

extension AthleteTableViewController {
    
    func style() {
        navigationItem.title = "My Favourite Athletes"
        navigationItem.rightBarButtonItem = addButton
        
        addButton.target = self
        addButton.action = #selector(addAthlete)
        
    }
    
}


