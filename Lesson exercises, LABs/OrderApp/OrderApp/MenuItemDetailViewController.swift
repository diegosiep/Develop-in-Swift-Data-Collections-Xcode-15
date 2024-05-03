//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Diego Sierra on 01/05/24.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    static let reuseIdentifier = "MenuItemDetail"
    
    var verticalStackView: UIStackView!
    var imageView: UIImageView!
    var horizontalStackView: UIStackView!
    var itemNameLabel: UILabel!
    var priceLabel: UILabel!
    var detailTextLabel: UILabel!
    var addToOrderButton: UIButton!
    
    let menuItem: MenuItem
    
    init?(menuitem: MenuItem) {
        menuItem = menuitem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
}

// MARK: - Style and layout methods

extension MenuItemDetailViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        
        imageView = UIImageView(image: UIImage(systemName: "photo.on.rectangle"))
        imageView.contentMode = .scaleAspectFit
        
        itemNameLabel = UILabel()
        itemNameLabel.text = menuItem.name
        
        priceLabel = UILabel()
        priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
        
        detailTextLabel = UILabel()
        detailTextLabel.numberOfLines = 0
        detailTextLabel.text = menuItem.detailText
        
        horizontalStackView = UIStackView(arrangedSubviews: [itemNameLabel, priceLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView = UIStackView(arrangedSubviews: [imageView, horizontalStackView, detailTextLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verticalStackView)
        
        addToOrderButton = UIButton(type: .system)
        addToOrderButton.tintColor = .white
        addToOrderButton.backgroundColor = .systemBlue
        addToOrderButton.setTitle("Add To Order", for: .normal)
        addToOrderButton.layer.cornerRadius = 5
        addToOrderButton.translatesAutoresizingMaskIntoConstraints = false
        addToOrderButton.addTarget(self, action: #selector(orderButtonTapped(_ :)), for: .touchUpInside)
        
        view.addSubview(addToOrderButton)
    }
    
    private func layout() {
        itemNameLabel.setContentHuggingPriority(.init(250), for: .horizontal)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 16),
            
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            
            addToOrderButton.heightAnchor.constraint(equalToConstant: 44),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: addToOrderButton.bottomAnchor, constant: 16),
            addToOrderButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: addToOrderButton.trailingAnchor, constant: 16)
        ])
    }
    
}

// MARK: - General methods

extension MenuItemDetailViewController {
    @objc func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1) {
            self.addToOrderButton.transform =
            CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton.transform =
            CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        MenuController.shared.order.menuItems.append(menuItem)
    }
}

// MARK: - Preview Provider

@available (iOS 17, *)

#Preview {
    UINavigationController(rootViewController: MenuItemDetailViewController(menuitem: MenuItem(id: 1, name: "Lasagna", detailText: "Delicious", price: 9.00, category: "Appetizers", imageURL: URL(string: "Example")!))!)
}
