//
//  AddEditEmojiTableViewCell.swift
//  EmojiDictionary
//
//  Created by Diego Sierra on 16/02/24.
//

import UIKit

class AddEditEmojiTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AddEditEmojiTableViewCell"
    let textField = UITextField()
    let sectionTypePicker = UIPickerView()
    let emojiSections = Section.allCases.sorted()
    var isSectionTypePicker: Bool {
        get {
            false
        }
        set {
            if newValue {
                setSectionTypePickerStyle()
                setSectionTypePickerLayout()
            }
        }
    }
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupStyleForTextFieldCell()
        self.setupLayoutForTextFieldCell()
    }
    
    init(isSectionTypePicker: Bool) {
        super.init(style: .default, reuseIdentifier: "CategoryPicker")
        self.isSectionTypePicker = isSectionTypePicker
        self.setupStyleForTextFieldCell()
        self.setupLayoutForTextFieldCell()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Setup style and layout methods for UITableViewCell
extension AddEditEmojiTableViewCell {
    func setupStyleForTextFieldCell() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)
    }
    
    func setupLayoutForTextFieldCell() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 2)
        ])
    }
    
    func setSectionTypePickerStyle() {
        sectionTypePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sectionTypePicker)
        sectionTypePicker.delegate = self
        textField.isHidden = true
    }
    
    func setSectionTypePickerLayout() {
        NSLayoutConstraint.activate([
            sectionTypePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            sectionTypePicker.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 0),
            contentView.bottomAnchor.constraint(equalTo: sectionTypePicker.bottomAnchor),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: sectionTypePicker.trailingAnchor, multiplier: 0),

            
        ])
    }
    
    func configureTextField(with string: String) {
        self.textField.text = string
    }
    
    func configureSectionTypePicker(with emoji: Emoji) {
        let currentEmojiSectionType = emojiSections.firstIndex(of: emoji.section)
        guard let currentEmojiSectionType = currentEmojiSectionType else { return }
        sectionTypePicker.selectRow(currentEmojiSectionType, inComponent: 0, animated: true)
    }
    
    func configureSectionTypePickerViews(with emojiSectionType: Section) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = emojiSectionType.rawValue
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8)
        ])
        
        return view
    }
}

extension AddEditEmojiTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        emojiSections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var sectionTypePickerView: UIView
        switch row {
        case 0:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[0])
            return sectionTypePickerView
        case 1:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[1])
            return sectionTypePickerView
        case 2:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[2])
            return sectionTypePickerView
        case 3:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[3])
            return sectionTypePickerView
        case 4:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[4])
            return sectionTypePickerView
        case 5:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[5])
            return sectionTypePickerView
        case 6:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[6])
            return sectionTypePickerView
        case 7:
            sectionTypePickerView = configureSectionTypePickerViews(with: emojiSections[7])
            return sectionTypePickerView
        default:
            fatalError("Could not configure picker view")
        }
    }
}

@available (iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 100), body: {
    AddEditEmojiTableViewCell(isSectionTypePicker: false)
})
