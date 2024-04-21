//
//  ViewController.swift
//  ISpy
//
//  Created by Diego Sierra on 12/02/24.
//

import UIKit

class ViewController: UIViewController {
    let scrollView = UIScrollView()
    let imageView = UIImageView(image: UIImage(named: "Oli"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateZoom(size: view.bounds.size)
    }
    
}

// MARK: General methods
extension ViewController {
    func updateZoom(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
    }
}

// MARK: Setup methods
extension ViewController {
    func style() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
}

//MARK: ScrollViewDelegate methods
extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: Preview Provider
@available (iOS 17,*)
#Preview {
    ViewController()
}
