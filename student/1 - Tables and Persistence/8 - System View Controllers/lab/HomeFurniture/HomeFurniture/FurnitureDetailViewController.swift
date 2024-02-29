
import UIKit
import PhotosUI

class FurnitureDetailViewController: UIViewController, UINavigationControllerDelegate {
    var furniture: Furniture?
    
    private var selectedAssetIdentifier = [String]()
    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    
    var photoImageView = UIImageView()
    var choosePhotoButton = UIButton()
    var furnitureTitleLabel = UILabel()
    var furnitureDescriptionLabel = UILabel()
    var actionButton = UIBarButtonItem()
    
    init(furniture: Furniture?) {
        self.furniture = furniture
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        style()
        layout()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
           let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = UIImage(systemName: "exclamationmark.octagon")
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    
}

// MARK: - Layout and Style methods for UIViewController

extension FurnitureDetailViewController {
    func style() {
        view.backgroundColor = .systemBackground
        navigationController?.isToolbarHidden = false
        toolbarItems = [actionButton]
        view.addSubview(photoImageView)
        view.addSubview(choosePhotoButton)
        view.addSubview(furnitureTitleLabel)
        view.addSubview(furnitureDescriptionLabel)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        
        furnitureTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        furnitureTitleLabel.font = UIFont.systemFont(ofSize: 25)
        
        furnitureDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        furnitureDescriptionLabel.font = UIFont.systemFont(ofSize: 17)
        
        actionButton.image = UIImage(systemName: "square.and.arrow.up")
        actionButton.target = self
        actionButton.action = #selector(actionButtonTapped(_ :))
        
        choosePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        choosePhotoButton.setTitle("Choose Photo", for: .normal)
        choosePhotoButton.setTitleColor(.systemBlue, for: .normal)
        choosePhotoButton.addTarget(self, action: #selector(choosePhotoButtonTapped(_ :)), for: .touchUpInside)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            choosePhotoButton.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            choosePhotoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: choosePhotoButton.trailingAnchor),
            
            furnitureTitleLabel.topAnchor.constraint(equalTo: choosePhotoButton.bottomAnchor),
            furnitureTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: furnitureTitleLabel.trailingAnchor, constant: 16),
            
            furnitureDescriptionLabel.topAnchor.constraint(equalTo: furnitureTitleLabel.bottomAnchor, constant: 8),
            furnitureDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: furnitureDescriptionLabel.trailingAnchor, constant: 16),
        ])
    }
}

// MARK: - Other general methods

extension FurnitureDetailViewController {
    @objc func actionButtonTapped(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [furniture?.imageData ?? UIImage(systemName: "square.and.arrow.up")!, furniture?.description ?? "Something went wrong"], applicationActivities: nil)
        
        present(activityViewController, animated: true)
        
    }
    
    @objc func choosePhotoButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { library in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.preselectedAssetIdentifiers = self.selectedAssetIdentifier
            
            let picker = PHPickerViewController(configuration: configuration)
            
            picker.delegate = self
            
            self.present(picker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(photoLibraryAction)
        alertController.popoverPresentationController?.sourceView = sender as? UIButton
        
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
                    self?.photoImageView.image = image
                    let imageData = image.jpegData(compressionQuality: 0.9)
                    self?.furniture?.imageData = imageData
                }
            }
        }
    }
}

// MARK: - Protocol conformances

extension FurnitureDetailViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = result
        }
        
        selection = newSelection
        selectedAssetIdentifier = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifier.makeIterator()
        
        displaySelectedImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        photoImageView.image = selectedImage
        let imageData = selectedImage.jpegData(compressionQuality: 0.9)
        self.furniture?.imageData = imageData
        updateView()
        dismiss(animated: true)
    }
    
}

@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: FurnitureDetailViewController(furniture: Furniture(name: "Chair", description: "For sitting")))
    
}
