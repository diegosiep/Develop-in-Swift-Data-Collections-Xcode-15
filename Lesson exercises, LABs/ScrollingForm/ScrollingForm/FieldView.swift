//
//  Field.swift
//  ScrollingForm
//
//  Created by Diego Sierra on 11/02/24.
//

import UIKit

class FieldView: UIView {
    let label = UILabel()
    let textField = UITextField()
    
    init(text: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setFieldViewValues(text)
        layout()
        style()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}

extension FieldView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
    
    }
    
    func layout() {
        self.addSubview(label)
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            
        ])
    }
    
    func setFieldViewValues(_ text: String) {
        self.label.text = text
    }
   
}

// Previews: Swift Macro
@available(iOS 17, *)
#Preview {
    FieldView(text: "First Name")
}


