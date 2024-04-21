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
    
    var photoInfo: PhotoInfo?
    let photoInfoController = PhotoInfoController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        style()
        layout()
    }
}

// MARK: - General methods

extension ViewController {
    private func updateUI() {
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                self.photoInfo = photoInfo
                try await checkIfAPODIsImageOrVideo()
            } catch {
                updateUI(error)
            }
        }
    }
    
    private func updateUI(_ error: Error) {
        self.title = "Error Fetching Photo"
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = ""
        self.imageView.image = UIImage(systemName: "exclamationmark.triangle")
        progressView.isHidden = true
    }
    
    private func checkIfAPODIsImageOrVideo() async throws {
        guard let photoInfo = self.photoInfo else { return }
        
        if photoInfo.mediaType == MediaType.video.rawValue {
            await UIApplication.shared.open(self.photoInfo!.url)
            self.title = photoInfo.title
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(openAPODURL))
            self.descriptionLabel.text = "Check out the APOD video! " + photoInfo.description
            self.copyrightLabel.text = photoInfo.copyright
            self.imageView.image = UIImage(systemName: "arrow.up.right.video")
            progressView.isHidden = true
        } else if photoInfo.mediaType == MediaType.image.rawValue {
            let image = try await photoInfoController.fetchPhotoImage(with: photoInfo)
            self.title = photoInfo.title
            self.descriptionLabel.text = photoInfo.description
            self.copyrightLabel.text = photoInfo.copyright
            self.imageView.image = image
            progressView.isHidden = true
        }
    }
    
    @objc func openAPODURL() {
        UIApplication.shared.open(photoInfo!.url)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
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
        
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(1.0, animated: true)
        imageView.addSubview(progressView)
        
        updateUI()
        
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
            progressView.widthAnchor.constraint(equalTo: imageView
                .widthAnchor)
            
        ])
    }
}


// MARK: - Preview Provider

@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: ViewController())
}
