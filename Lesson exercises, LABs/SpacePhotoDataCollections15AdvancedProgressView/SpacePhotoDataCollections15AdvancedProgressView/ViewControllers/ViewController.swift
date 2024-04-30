//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Diego Sierra on 14/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var imageView: UIImageView!
    var descriptionLabel: UILabel!
    var copyrightLabel: UILabel!
    var progressView: UIProgressView!
    var photoInfo: SpacePhoto?
    
    var receivedData: Data?
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var downloadPhotoInfoTask: URLSessionDownloadTask? = nil
    var downloadPhotoInfoImageTask: URLSessionDownloadTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

// MARK: - General methods

extension ViewController {
  
    
    func updateUI(with spacePhoto: SpacePhoto) {
        self.descriptionLabel.text = photoInfo?.description
        self.copyrightLabel.text = photoInfo?.copyright
        self.title = photoInfo?.title
        switch spacePhoto.mediaType {
        case MediaType.image.rawValue:
            self.fetchPhotoImage(with: spacePhoto.url)
        case MediaType.video.rawValue:
            fetchPhotoInfoVideoInfo(with: spacePhoto.thumbnailUrl ?? URL(string: "https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.svg")!)
        default:
            self.imageView.image = UIImage(systemName: "exclamationmark.triangle")
            
        }
        
    }
    
    func updateUI(_ error: Error) {
        self.title = "Error Fetching Photo"
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
        self.imageView.image = UIImage(systemName: "exclamationmark.triangle")
        progressView.isHidden = true
    }

    @objc func openAPODURL() {
        UIApplication.shared.open(photoInfo!.url)
    }
    
    
}

// MARK: - Style and layout methods

extension ViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        stackView.addArrangedSubview(descriptionLabel)
        
        copyrightLabel = UILabel()
        copyrightLabel.numberOfLines = 0
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(copyrightLabel)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.isHidden = false
        imageView.addSubview(progressView)
        
        fetchPhotoInfo()
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            
            progressView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
        ])
    }
}


// MARK: - Preview Provider

@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: ViewController())
}
