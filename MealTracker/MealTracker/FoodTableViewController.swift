//
//  FoodTableViewController.swift
//  MealTracker
//
//  Created by Diego Sierra on 15/02/24.
//

import UIKit

class FoodTableViewController: UITableViewController {
    var meals: [Meal] {
        let breakfast = Meal(name: "Breakfast", food: [Food(name: "Eggs", description: "Eggs"), Food(name: "Bread", description: "Bread"), Food(name: "Coffee", description: "Coffee")])
        let lunch = Meal(name: "Lunch", food: [Food(name: "Lentil soup", description: "Lentil sopu"), Food(name: "Meat", description: "Meat"), Food(name: "Salad", description: "Salad")])
        let dinner = Meal(name: "Dinner", food: [Food(name: "Salmon", description: "Salmon"), Food(name: "Apple", description: "Apple"), Food(name: "Couscous", description: "Couscous")])
        
        return [breakfast, lunch, dinner]
    }
    
    let reuseIdentifier = "Food"
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals[section].food.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let meal = meals[indexPath.section].food[indexPath.row]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = meal.name
        contentConfiguration.secondaryText = meal.description
        cell.contentConfiguration = contentConfiguration
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meals[section].name
    }
    
}

extension FoodTableViewController {
    func style() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        title = "Meal Tracker"
    }
    
    func layout() {
        
    }
}



