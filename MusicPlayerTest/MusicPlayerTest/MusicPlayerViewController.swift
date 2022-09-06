//
//  MusicPlayerViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.09.22.
//

import UIKit

final class MusicPlayerViewController: UIViewController {
    
    private var songs = [
        Song(name: "Take It Smart", image: "Take it Smart Boris Brejcha", artist: "Boris Brejcha", fileName: "Boris_Brejcha_-_Take_It_Smart_(musmore.com)"),
        Song(name: "FILV x LINIUS", image: "FILV x LINIUS Malumup", artist: "Malumup", fileName: "Malumup - FILV x LINIUS - Dont Wanna Go Home"),
        Song(name: "Mask", image: "Mask KVPV", artist: "KVPV", fileName: "KVPV - Mask")
        ]
 //   var song: [Song]
    
    private lazy var mediaPlayer: MediaPlayer = {
        let player = MediaPlayer(song: songs)
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
//    init(song: [Song]) {
//        self.songs = song
//        super.init(nibName: nil, bundle: nil)
//    }
//    
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaPlayer.backgroundColor = .red
        setupView()
    }
    
    private func setupView() {
        addBlurrView()
        view.addSubview(mediaPlayer)
        
        setupConstraints()
            
        
    }
    
    private func addBlurrView() {
        if UIAccessibility.isReduceTransparencyEnabled {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = UIColor.black
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaPlayer.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mediaPlayer.play()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mediaPlayer.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
