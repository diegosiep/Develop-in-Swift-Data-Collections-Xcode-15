
import UIKit
import Speech

@MainActor
class StoreItemListTableViewController: UITableViewController, SFSpeechRecognizerDelegate {
    
    static let reuseIdentifier = "ItemCell"
    
    var searchBar: UISearchBar!
    var filterSegmentedControl: UISegmentedControl!
    
    var storeItemController = StoreItemController()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-GB"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    // add item controller property
    
    var items: [StoreItem] = []
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreItemListTableViewController.reuseIdentifier, for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)
        
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cancel the image fetching task if we no longer need it
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

// MARK: - Layout and Style methods

extension StoreItemListTableViewController {
    private func style() {
        tableView.register(ItemCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        
        filterSegmentedControl = UISegmentedControl(items: ["Movies", "Music", "Apps", "Books"])
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(filterOptionUpdated(_ :)), for: .valueChanged)
        navigationItem.titleView = filterSegmentedControl
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.accessibilityTraits = .button
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: [])
        searchBar.delegate = self
        tableView.addSubview(searchBar)
        
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor),
            tableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            
        ])
    }
}


// MARK: - General Methods
extension StoreItemListTableViewController {
    
    func fetchMatchingItems() {
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            let queryDictionary = [
                "term": searchTerm,
                "media": mediaType,
                "limit": "30"
            ]
            
            Task {
                do {
                    let searchResponse = try await storeItemController.fetchItems(matching: queryDictionary)
                    self.items = searchResponse
                    tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc  func filterOptionUpdated(_ sender: UISegmentedControl) {
        fetchMatchingItems()
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        // set cell.name to the item's name
        cell.name = item.trackName
        
        // set cell.artist to the item's artist
        cell.artist = item.artistName
        
        // set cell.artworkImage to nil
        
        
        // initialize a network task to fetch the item's artwork keeping track of the task
        // in imageLoadTasks so they can be cancelled if the cell will not be shown after
        // the task completes.
        imageLoadTasks[indexPath] = Task {
            do {
                let artworkImage = try await storeItemController.fetchItemImage(with: item.artworkUrl)
                cell.artworkImage = artworkImage
            } catch {
                cell.artworkImage = nil
                print(error)
            }
        }
        // if successful, set the cell.artworkImage using the returned image
    }
    
    private func startRecording() throws {
        
        //         Cancel any other previous recognition tasks.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest() // For handling live input speech recognition audio.
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode //  The input node represents the current audio input path, which can be the device’s built-in microphone or a microphone connected to a set of headphones.
        
        //        Configure the microphone input.
        //         To begin recording, the app installs a tap on the input node and starts up the audio engine, which begins collecting samples into an internal buffer. When a buffer is full, the audio engine calls the provided block. The app’s implementation of that block passes the samples directly to the request object’s append(_:) method, which accumulates the audio samples and delivers them to the speech recognition system.
        inputNode.removeTap(onBus: 0)
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, avAudtioTime in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        AudioServicesPlaySystemSound(SystemSoundID(1113))
        
        // Create and configure the speech recognition request.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            var isFinal = false
            
            if let result = result {
                
                self.searchBar.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                AudioServicesPlaySystemSound(SystemSoundID(1114))
                inputNode.removeTap(onBus: 0)
                
                recognitionRequest.endAudio()
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                
            }
        })
    }
    
    private func shouldStopAudioEngine() {
        if self.audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: [])
        }
    }
}


// MARK: - Protocol conformances
extension StoreItemListTableViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            OperationQueue.main.addOperation {
                switch authStatus {
                case .notDetermined:
                    break
                case .denied:
                    self.searchBar.setImage(UIImage(systemName: "mic.slash"), for: .bookmark, state: [])
                    let alertDeniedPermission = UIAlertController(title: "Speech Recognition denied", message: "You have denied permission to allow dictation. To change speech recording permission preferences, go to Settings and allow voice recording for this app.", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
                        alertDeniedPermission.dismiss(animated: true)
                    }
                    alertDeniedPermission.addAction(dismissAction)
                    self.present(alertDeniedPermission, animated: true)
                case .restricted:
                    break
                case .authorized:
                    
                    if self.audioEngine.isRunning {
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
                        self.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: [])
                        self.fetchMatchingItems()
                    } else {
                        do {
                            
                            try self.startRecording()
                            self.searchBar.setImage(UIImage(systemName: "mic.circle.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.systemBlue])), for: .bookmark, state: [])
                        } catch {
                            print(error)
                        }
                    }
                @unknown default:
                    break
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingItems()
        shouldStopAudioEngine()
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldStopAudioEngine()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shouldStopAudioEngine()
    }
    
}

// MARK: - Preview Provider

@available (iOS 17, *)
#Preview {
    UINavigationController(rootViewController: StoreItemListTableViewController(style: .plain))
}
