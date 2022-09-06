//
//  MediaPlayer.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.09.22.
//

import UIKit
import AVKit

final class MediaPlayer: UIView {
    
    var song: [Song]
    private var player = AVAudioPlayer()
    private var timer: Timer?
    private var playingIndex = 0
    
    init(song: [Song]) {
        self.song = song
        super.init(frame: .zero)
        setupView()
    }
    
//   private var seconds: Int = 0 {
//        didSet {
//            let min = Int(Double(self.seconds) / 60.0)
//            let sec = Int(Double(self.seconds) - (Double(min) * 60.0))
//            let min_string = min < 10 ? "0\(min)" : "\(min)"
//            let sec_srting = sec < 10 ? "0\(sec)" : "\(sec)"
//            remainingTimeLabel.text = "\(min_string):\(sec_srting)"
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private lazy var songName: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .darkGray
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 32, weight: .bold)
//        return label
//    }()
    
    private lazy var songImage: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 80
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(progressScrubbed), for: .valueChanged)
        slider.minimumTrackTintColor = UIColor(named: "subtitleColor")
        return slider
    }()
    
    private lazy var elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "00:00"
        return label
    }()
    
    private lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.text = "00:00"
        return label
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(tapedPreviousSong), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 100)
        button.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(tapedPlayPause), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(tapedNextSong), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [previousButton, playPauseButton, nextButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private func setupView() {
        songNameLabel.text = song.first?.name
        songImage.image = UIImage(named: song.first?.image ?? "")
        artistNameLabel.text = song.first?.artist
        setupPlayer(song: song[playingIndex])

        [songNameLabel, artistNameLabel, elapsedTimeLabel, remainingTimeLabel].forEach({ label in
            label.textColor = .white
        })
        [songImage, songNameLabel, artistNameLabel, progressBar, elapsedTimeLabel, remainingTimeLabel, controlStack].forEach({ view in
            addSubview(view)
        })
        
        setupConstraints()
    }
    
    private func setupConstraints() {
          
        NSLayoutConstraint.activate([
            songImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            songImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            songImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
            ])
        
        NSLayoutConstraint.activate([
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            songNameLabel.topAnchor.constraint(equalTo: songImage.bottomAnchor, constant: 16)
            ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            elapsedTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            elapsedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            remainingTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            controlStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            controlStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            controlStack.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 8)
            ])
        
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else { return }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(updateProcess), userInfo: nil, repeats: true)
        }
        songNameLabel.text = song.name
        artistNameLabel.text = song.artist
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func play() {
        progressBar.value = 0.0
        progressBar.maximumValue = Float(player.duration)
        player.play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    func stop() {
        player.stop()
        timer?.invalidate()
        timer = nil
    }
    
    private func setPlayPauseIcon(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 100)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill", withConfiguration: config), for: .normal)
    }
    
    
    @objc private func updateProcess() {
        progressBar.value = Float(player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = "\(remainingTime)"
    }
    
    @objc private func tapedPreviousSong(_ sender: UIButton) {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = song.count - 1
        }
        setupPlayer(song: song[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func tapedNextSong(_ sender: UIButton) {
        playingIndex += 1
        if playingIndex >= song.count {
            playingIndex = 0
        }
        setupPlayer(song: song[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func tapedPlayPause(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        setPlayPauseIcon(isPlaying: player.isPlaying)
    }
    
    @objc private func progressScrubbed(_ sender: UISlider) {
        player.currentTime = Float64(sender.value)
    }
    
    
    
    private func fetFormattedTime(timeInterval: TimeInterval) -> String {
        return ""
    }
    
}

extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        tapedNextSong(nextButton)
    }
}
