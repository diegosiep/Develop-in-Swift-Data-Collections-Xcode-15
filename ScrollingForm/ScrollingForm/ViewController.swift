//
//  ViewController.swift
//  ScrollingForm
//
//  Created by Diego Sierra on 11/02/24.
//

import UIKit

class ViewController: UIViewController {
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let nameFieldView = FieldView(text: "First Name")
    let lastNameFieldView = FieldView(text: "Last Name")
    let addressLine1FieldView = FieldView(text: "Address Line 1")
    let addressLine2FieldView = FieldView(text: "Address Line 2")
    let cityFieldView = FieldView(text: "City")
    let stateFieldView = FieldView(text: "State")
    let postalCodeFieldView = FieldView(text: "Postal Code")
    let phoneNumberFieldView = FieldView(text: "Phone Number")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        registerForKeyboardNotifications()
    }
}

// MARK: Functions
extension ViewController {
    func style() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill

    }
    
    func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(nameFieldView)
        stackView.addArrangedSubview(lastNameFieldView)
        stackView.addArrangedSubview(addressLine1FieldView)
        stackView.addArrangedSubview(addressLine2FieldView)
        stackView.addArrangedSubview(cityFieldView)
        stackView.addArrangedSubview(stateFieldView)
        stackView.addArrangedSubview(postalCodeFieldView)
        stackView.addArrangedSubview(phoneNumberFieldView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1, constant: 0),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
          
        ])
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

// Previews: Swift Macro
@available(iOS 17, *)
#Preview {
    ViewController()
}
