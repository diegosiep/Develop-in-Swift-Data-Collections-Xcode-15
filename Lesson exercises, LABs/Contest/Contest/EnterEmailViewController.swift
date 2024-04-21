//
//  ViewController.swift
//  Contest
//
//  Created by Diego Sierra on 10/04/24.
//

import UIKit

class EnterEmailViewController: UIViewController {
    var label: UILabel!
    var textField: UITextField!
    var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}


// MARK: - General methods
extension EnterEmailViewController {
    @objc func submitEmailAddress() {
        let successfulContestViewController = SuccessfulContestViewController()
        
        guard !textField.text!.isEmpty else {
            UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [.layoutSubviews]) {
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform(translationX: 20, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform(translationX: -20, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform(translationX: 20, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform(translationX: -20, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform(translationX: 20, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform(translationX: -20, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                    self.textField.transform = CGAffineTransform.identity
                }
            }
            return
        }
        navigationController?.pushViewController(successfulContestViewController, animated: true)
    }
}

// MARK: - Style and layout methods
extension EnterEmailViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        
        label = UILabel()
        label.text = "Enter E-mail address to enter the contest"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        view.addSubview(label)
        
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.placeholder = "Enter e-mail address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 15
        submitButton.addTarget(self, action: #selector(submitEmailAddress), for: .primaryActionTriggered)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 15),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 15),
            
            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 100),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 15),
        ])
    }
}

// MARK: - Preview Provider
@available (iOS 17, *)
#Preview {
    return UINavigationController(rootViewController: EnterEmailViewController())
}

