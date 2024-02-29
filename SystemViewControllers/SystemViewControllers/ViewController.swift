//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Diego Sierra on 27/02/24.
//

import UIKit
import SafariServices
import MessageUI
import PhotosUI
import Messages

class ViewController: UIViewController {
    private var selectedAssetIdentifiers = [String]()
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    
    let horizontalStackView = UIStackView()
    let imageView = UIImageView()
    let shareButton = UIButton()
    let safariButton = UIButton()
    let cameraButton = UIButton()
    let emailButton = UIButton()
    let messageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    
}

// MARK: - Layout and setup files

extension ViewController {
    func setup() {
        view.addSubview(imageView)
        view.addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.addArrangedSubview(emailButton)
        horizontalStackView.addArrangedSubview(shareButton)
        horizontalStackView.addArrangedSubview(safariButton)
        horizontalStackView.addArrangedSubview(cameraButton)
        horizontalStackView.addArrangedSubview(messageButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Oliver")
        imageView.contentMode = .scaleAspectFit
        
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.setImage(UIImage(systemName: "message"), for: .normal)
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        
        safariButton.translatesAutoresizingMaskIntoConstraints = false
        safariButton.setImage(UIImage(systemName: "safari"), for: .normal)
        safariButton.addTarget(self, action: #selector(safariButtonTapped(_:)), for: .touchUpInside)
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped(_:)), for: .touchUpInside)
        
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.setImage(UIImage(systemName: "envelope"), for: .normal)
        emailButton.addTarget(self, action: #selector(mailButtonTapped(_:)), for: .touchUpInside)
        

    }
    
    func layout() {

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
        
            horizontalStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor, constant: 16),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: horizontalStackView.bottomAnchor, multiplier: 1)
            
        ])
        
        
    }
}

extension ViewController {
    @objc func mailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send email")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["example@example.com"])
        mailComposer.setSubject("Have a look at this")
        mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false)
        
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9) {
            mailComposer.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        
        present(mailComposer, animated: true)
        
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    @objc func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.apple.com/mx") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
      
    }
    
    @objc func messageButtonTapped(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText(), MFMessageComposeViewController.canSendAttachments() else { print("Cannot send text"); return }
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = ["TypeInANumber"]
        composeVC.body = "Hello!"
        
        guard let image = imageView.image, let encodedImage = image.jpegData(compressionQuality: 0.9) else { return }
        composeVC.addAttachmentData(encodedImage, typeIdentifier: "public.jpeg", filename: "oliver_picture.jpg")
        
        present(composeVC, animated: true)
    }
    
    @objc func cameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.preselectedAssetIdentifiers = self.selectedAssetIdentifiers
            
            let picker = PHPickerViewController(configuration: configuration)
            
            picker.delegate = self
            self.present(picker, animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(photoLibraryAction)
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true)
    }
    
    func displaySelectedImage() {
        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else {
            return
        }
        
        let itemProvider = selection[assetIdentifier]!.itemProvider
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
}

// MARK: - Protocol conformances

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        var newSelection = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = result
        }
        
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()
        
        displaySelectedImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = selectedImage
        dismiss(animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - PreviewProvider

@available (iOS 17, *)
#Preview {
    ViewController()
}
