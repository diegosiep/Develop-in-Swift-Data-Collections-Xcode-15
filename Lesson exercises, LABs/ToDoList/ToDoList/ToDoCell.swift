//
//  toDoTableViewCell.swift
//  ToDoList
//
//  Created by Diego Sierra on 25/03/24.
//

import UIKit

protocol ToDoCellDelegate: AnyObject {
    func checkMarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    static let reuseIdentifier = "ToDoTableViewCellReuseIdentifier"
    
    weak var delegate: ToDoCellDelegate?
    
    var checkmarkButton: UIButton!
    
    var toDoTitleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Syle and layout methods for TableViewCell
extension ToDoCell {
    private func style() {
        checkmarkButton = UIButton()
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkmarkButton.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)
        checkmarkButton.addTarget(self, action: #selector(completeButtonTapped(_ :)), for: .touchUpInside)
        contentView.addSubview(checkmarkButton)
        
        toDoTitleLabel = UILabel()
        toDoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoTitleLabel.text = "ToDo"
        contentView.addSubview(toDoTitleLabel)
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: checkmarkButton.bottomAnchor, constant: 8),
            
            toDoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: toDoTitleLabel.bottomAnchor, constant: 8),
            toDoTitleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 8),
            
            
        ])
    }
}

// MARK: - General methods

extension ToDoCell {
    @objc func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkMarkTapped(sender: self)
    }
}

// MARK: - Preview Provider
@available (iOS 17, *)
#Preview(nil, traits: .fixedLayout(width: 300, height: 60), body: {
    ToDoCell()
})
