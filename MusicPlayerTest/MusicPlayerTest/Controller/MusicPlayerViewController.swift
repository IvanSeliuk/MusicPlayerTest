//
//  MusicPlayerViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.09.22.
//

import UIKit

final class MusicPlayerViewController: UIViewController {
    
    private var songs = [
        Song(name: "Take It Smart", image: "Take it Smart Boris Brejcha1", artist: "Boris Brejcha", fileName: "Boris_Brejcha_-_Take_It_Smart_(musmore.com)"),
        Song(name: "FILV x LINIUS", image: "FILV x LINIUS Malumup", artist: "Malumup", fileName: "Malumup - FILV x LINIUS - Dont Wanna Go Home"),
        Song(name: "Mask", image: "Mask KVPV", artist: "KVPV", fileName: "KVPV - Mask")
    ]
    
    private lazy var mediaPlayer: MediaPlayer = {
        let player = MediaPlayer(song: songs)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.backgroundColor = .clear
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(mediaPlayer)
        setupConstraints()
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
