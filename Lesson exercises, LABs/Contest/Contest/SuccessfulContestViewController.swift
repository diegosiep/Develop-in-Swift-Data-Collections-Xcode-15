//
//  SuccessfulContestViewController.swift
//  Contest
//
//  Created by Diego Sierra on 11/04/24.
//

import UIKit

class SuccessfulContestViewController: UIViewController {
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have succesfully entered the contest!"
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

// MARK: - Preview provider

@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: SuccessfulContestViewController())
}
