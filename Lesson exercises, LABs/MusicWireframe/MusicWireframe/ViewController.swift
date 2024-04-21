//
//  ViewController.swift
//  MusicWireframe
//
//  Created by Diego Sierra on 09/04/24.
//

import UIKit

class ViewController: UIViewController {
    var albumImageView: UIImageView!
    
    var horizontalStackView: UIStackView!
    
    var reverseBackground: UIView!
    var playPauseBackground: UIView!
    var forwardBackground: UIView!
    
    var reverseButton: UIButton!
    var playPauseButton: UIButton!
    var forwardButton: UIButton!
    
    var isPlaying: Bool = true {
        didSet {
            playPauseButton.isSelected = isPlaying
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ViewController {
    @objc func playPauseButtonTapped(_ sender: UIButton) {
        isPlaying.toggle()
        
        if isPlaying {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
                self.albumImageView.transform = CGAffineTransform.identity
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    @objc func touchedDown(_ sender: UIButton) {
        let buttonBackground: UIView
        
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case playPauseButton:
            buttonBackground = playPauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            buttonBackground.alpha = 0.3
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @objc func touchedUpInside(_ sender: UIButton) {
        let buttonBackground: UIView
        
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case playPauseButton:
            buttonBackground = playPauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            buttonBackground.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            buttonBackground.alpha = 0
            sender.transform = CGAffineTransform.identity
        } completion: { _ in
            buttonBackground.transform = CGAffineTransform.identity
        }

    }
}



// MARK: - Layout and style methods
extension ViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        
        albumImageView = UIImageView()
        albumImageView.backgroundColor = .systemPink
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(albumImageView)
        
        horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStackView)
        
        reverseButton = UIButton()
        reverseButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        reverseButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        reverseButton.tintColor = .black
        reverseButton.translatesAutoresizingMaskIntoConstraints = false
        reverseButton.addTarget(self, action: #selector(touchedDown(_ :)), for: .touchDown)
        reverseButton.addTarget(self, action: #selector(touchedUpInside(_ :)), for: .touchUpInside)
        horizontalStackView.addArrangedSubview(reverseButton)
        
        reverseBackground = UIView()
        reverseBackground.backgroundColor = .lightGray
        reverseBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reverseBackground)
        view.sendSubviewToBack(reverseBackground)
        
        playPauseButton = UIButton()
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .selected)
        playPauseButton.isSelected = true
        playPauseButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        playPauseButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .selected)
        playPauseButton.tintColor = .black
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped(_ :)), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(touchedDown(_ :)), for: .touchDown)
        playPauseButton.addTarget(self, action: #selector(touchedUpInside(_ :)), for: .touchUpInside)
        horizontalStackView.addArrangedSubview(playPauseButton)
        
        playPauseBackground = UIView()
        playPauseBackground.backgroundColor = .lightGray
        playPauseBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playPauseBackground)
        view.sendSubviewToBack(playPauseBackground)
        
        forwardButton = UIButton()
        forwardButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        forwardButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        forwardButton.tintColor = .black
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.addTarget(self, action: #selector(touchedDown(_ :)), for: .touchDown)
        forwardButton.addTarget(self, action: #selector(touchedUpInside(_ :)), for: .touchUpInside)
        horizontalStackView.addArrangedSubview(forwardButton)
        
        forwardBackground = UIView()
        forwardBackground.backgroundColor = .lightGray
        forwardBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forwardBackground)
        view.sendSubviewToBack(forwardBackground)
        
        [reverseBackground, playPauseBackground, forwardBackground].forEach { view in
            view?.layer.cornerRadius = 27
            view?.clipsToBounds = true
            view?.alpha = 0.0
        }
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor, multiplier: 1),
            albumImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            albumImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 20),
            
            horizontalStackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 60),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor, constant: 40),
            
            reverseBackground.centerXAnchor.constraint(equalTo: reverseButton.centerXAnchor),
            reverseBackground.centerYAnchor.constraint(equalTo: reverseButton.centerYAnchor),
            reverseBackground.heightAnchor.constraint(equalTo: reverseButton.heightAnchor, multiplier: 1.5),
            reverseBackground.widthAnchor.constraint(equalTo: reverseBackground.heightAnchor, multiplier: 1),
            
            playPauseBackground.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor),
            playPauseBackground.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            playPauseBackground.heightAnchor.constraint(equalTo: playPauseButton.heightAnchor, multiplier: 1.5),
            playPauseBackground.widthAnchor.constraint(equalTo: playPauseBackground.heightAnchor, multiplier: 1),
            
            forwardBackground.centerXAnchor.constraint(equalTo: forwardButton.centerXAnchor),
            forwardBackground.centerYAnchor.constraint(equalTo: forwardButton.centerYAnchor),
            forwardBackground.heightAnchor.constraint(equalTo: forwardButton.heightAnchor, multiplier: 1.5),
            forwardBackground.widthAnchor.constraint(equalTo: forwardBackground.heightAnchor, multiplier: 1),
            
        ])
        
    }
}

// MARK: - PreviewProvider

@available(iOS 17.0, *)
#Preview {
    ViewController()
}

