//
//  ViewController.swift
//  AppEventCount
//
//  Created by Diego Sierra on 08/02/24.
//

import UIKit

class ViewController: UIViewController {
    let labelStackView = UIStackView()
    let didFinishLaunchingLabel = UILabel()
    let configurationForConnectingLabel = UILabel()
    let sceneWillConnectToLabel = UILabel()
    let sceneDidBecomeAciveLabel = UILabel()
    let sceneWillResignActiveLabel = UILabel()
    let sceneWillEnterForegroundLabel = UILabel()
    let sceneDidEnterBackgroundLabel = UILabel()
    
    var willConnectToCount = 0
    var didBecomeActiveCount = 0
    var willResignActiveCount = 0
    var willEnterForegroundCount = 0
    var didEnterBackgroundCount = 0
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        style()
        layout()
    }
    
    func updateView() {
        didFinishLaunchingLabel.text = "The app has launched \(appDelegate.launchCount) time(s)"
        configurationForConnectingLabel.text = "The app has created a new session \(appDelegate.configurationForConnectingCount) time(s)"
        sceneWillConnectToLabel.text = "The scene has connected \(willConnectToCount) time(s)"
        sceneDidBecomeAciveLabel.text = "The scene did become active \(didBecomeActiveCount) time(s)"
        sceneWillResignActiveLabel.text = "The scene resigned active \(willResignActiveCount) time(s)"
        sceneWillEnterForegroundLabel.text = "The scene has entered foreground \(willEnterForegroundCount) time(s)"
        sceneDidEnterBackgroundLabel.text = "The scene has entered background \(didEnterBackgroundCount) time(s)"
    }
    
    
    func style() {
        view.backgroundColor = .systemBackground
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        didFinishLaunchingLabel.translatesAutoresizingMaskIntoConstraints = false
        configurationForConnectingLabel.translatesAutoresizingMaskIntoConstraints = false
        sceneWillConnectToLabel.translatesAutoresizingMaskIntoConstraints = false
        sceneDidBecomeAciveLabel.translatesAutoresizingMaskIntoConstraints = false
        sceneWillResignActiveLabel.translatesAutoresizingMaskIntoConstraints = false
        sceneWillEnterForegroundLabel.translatesAutoresizingMaskIntoConstraints = false
        sceneDidEnterBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        didFinishLaunchingLabel.textAlignment = .center
        
        didFinishLaunchingLabel.textAlignment = .center
        
           
    }
    
    func layout() {
        view.addSubview(labelStackView)
        labelStackView.spacing = 20
        labelStackView.distribution = .equalSpacing
        labelStackView.axis = .vertical
        
        labelStackView.addArrangedSubview(didFinishLaunchingLabel)
        labelStackView.addArrangedSubview(configurationForConnectingLabel)
        labelStackView.addArrangedSubview(sceneWillConnectToLabel)
        labelStackView.addArrangedSubview(sceneDidBecomeAciveLabel)
        labelStackView.addArrangedSubview(sceneWillResignActiveLabel)
        labelStackView.addArrangedSubview(sceneWillEnterForegroundLabel)
        labelStackView.addArrangedSubview(sceneDidEnterBackgroundLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
}

