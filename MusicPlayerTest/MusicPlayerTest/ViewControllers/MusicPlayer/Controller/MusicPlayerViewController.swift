//
//  MusicPlayerViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.09.22.
//

import UIKit

final class MusicPlayerViewController: UIViewController {
    private var songs: [Song]
    private var index: Int
    
    
    init(songs: [Song], index: Int) {
        self.songs = songs
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mediaPlayer: MediaPlayer = {
        let player = MediaPlayer(song: songs, playingIndex: index)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.backgroundColor = .clear
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        closureAlertPresent()
//        print(CFGetRetainCount(mediaPlayer))
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
    
    private func closureAlertPresent() {
        mediaPlayer.presentAlertSettings = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "\(self.mediaPlayer.artistNameLabel.text ?? "") \n\(self.mediaPlayer.nameSongLabel.text ?? "")", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let playlist = UIAlertAction(title: "Add to Playlist", style: .default) { _ in
                print("to do new play list")
            }
            let similar = UIAlertAction(title:  "Find Similar", style: .default) { _ in
                print("to do find similar music")
            }
            let remove = UIAlertAction(title:  "Remove from My Music", style: .destructive) { _ in
                print("to do remove from My Music")
            }
            alert.addAction(cancel)
            alert.addAction(playlist)
            alert.addAction(similar)
            alert.addAction(remove)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
