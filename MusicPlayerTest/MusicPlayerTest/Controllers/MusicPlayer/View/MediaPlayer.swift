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
    private var playingIndex: Int
    private var isLike: Bool = false
    
    var presentAlertSettings: (() -> Void)?
    
    init(song: [Song], playingIndex: Int) {
        self.song = song
        self.playingIndex = playingIndex
        super.init(frame: .zero)
        setupView()
        animationNameView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var songImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 65
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var progressBar: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(progressScrubbed), for: .valueChanged)
        slider.minimumTrackTintColor = UIColor(named: "subtitleColor")
        slider.thumbTintColor = UIColor(named: "subtitleColor")
        slider.maximumTrackTintColor = .white
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
    
    lazy var nameSongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .light)
        return label
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(tapedPreviousSong), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(tapedPlayPause), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(tapedNextSong), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var volumSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.7
        slider.addTarget(self, action: #selector(setValueSlider), for: .valueChanged)
        slider.minimumTrackTintColor = .white
        slider.thumbTintColor = .white
        slider.maximumTrackTintColor = .lightGray
        return slider
    }()
    
    private lazy var volumDown: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 15)
        button.setImage(UIImage(systemName: "volume.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(takeVolumeDown), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var volumUp: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 15)
        button.setImage(UIImage(systemName: "volume.3.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(takeVolumeUp), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(clickLikeSong), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(setSettingsSong), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var controlStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeButton, previousButton, playPauseButton, nextButton, settingsButton],
                                axis: .horizontal,
                                spacing: 10,
                                distribution: .equalSpacing)
        return stack
    }()
    
    private lazy var volumeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [volumDown, volumSlider, volumUp],
                                axis: .horizontal,
                                spacing: 10,
                                distribution: .fill)
        return stack
    }()
    
    private func setupView() {
        backgroundImage.image = UIImage(named: "4d")
        nameSongLabel.text = song.first?.name
        songImage.image = UIImage(named: song.first?.image ?? "")
        artistNameLabel.text = song.first?.artist
        setupPlayer(song: song[playingIndex])
        
        [nameSongLabel, artistNameLabel, elapsedTimeLabel, remainingTimeLabel].forEach({ label in
            label.textColor = .white
        })
        
        [backgroundImage, songImage, nameSongLabel, artistNameLabel, progressBar, elapsedTimeLabel, remainingTimeLabel, controlStack, volumeStack].forEach({ view in
            addSubview(view)
        })
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            songImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            songImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            songImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.5)
        ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            artistNameLabel.topAnchor.constraint(equalTo: songImage.bottomAnchor, constant: 32)
        ])
        
        NSLayoutConstraint.activate([
            nameSongLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameSongLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameSongLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            progressBar.topAnchor.constraint(equalTo: nameSongLabel.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            remainingTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            elapsedTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            elapsedTimeLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            controlStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            controlStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            controlStack.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 32)
        ])
        
        NSLayoutConstraint.activate([
            volumeStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            volumeStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            volumeStack.topAnchor.constraint(equalTo: controlStack.bottomAnchor, constant: 40)
            ])
    }
    
    private func setupPlayer(song: Song) {
        guard let url = Bundle.main.url(forResource: song.fileName, withExtension: "mp3") else { return }
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(updateProcess), userInfo: nil, repeats: true)
        }
        nameSongLabel.text = song.name
        artistNameLabel.text = song.artist
        songImage.image = UIImage(named: song.image)
        
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
        let config = UIImage.SymbolConfiguration(pointSize: 50)
        playPauseButton.setImage(UIImage(systemName: isPlaying ? "pause.fill" : "play.fill", withConfiguration: config), for: .normal)
    }
    
    @objc private func updateProcess() {
        progressBar.value = Float(player.currentTime)
        elapsedTimeLabel.text = getFormattedTime(timeInterval: player.currentTime)
        let remainingTime = player.duration - player.currentTime
        remainingTimeLabel.text = getFormattedTime(timeInterval: remainingTime)
    }
    
    @objc private func tapedPreviousSong(_ sender: UIButton) {
        playingIndex -= 1
        if playingIndex < 0 {
            playingIndex = song.count - 1
        }
        setupPlayer(song: song[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
        animationNameView()
        setValueSlider()
    }
    
    @objc private func tapedNextSong(_ sender: UIButton) {
        playingIndex += 1
        if playingIndex >= song.count {
            playingIndex = 0
        }
        setupPlayer(song: song[playingIndex])
        play()
        setPlayPauseIcon(isPlaying: player.isPlaying)
        animationNameView()
        setValueSlider()
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
    
    @objc private func setValueSlider() {
        player.volume = volumSlider.value
    }
    
    
    @objc private func takeVolumeDown() {
        player.volume = 0
        volumSlider.value = 0
    }
    
    
    @objc private func takeVolumeUp() {
        player.volume = 1.0
        volumSlider.value = 1.0
    }
    
    @objc private func clickLikeSong() {
        if isLike {
            let config = UIImage.SymbolConfiguration(pointSize: 25)
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
            isLike = false
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 25)
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
            isLike = true
        }
    }
    
    @objc private func setSettingsSong() {
        presentAlertSettings?()
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let min = timeInterval / 60
        let sec = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let min_string = timeFormatter.string(from: NSNumber(value: min)), let sec_string = timeFormatter.string(from: NSNumber(value: sec)) else { return "00:00" }
        return "\(min_string):\(sec_string)"
    }
    
    private func animationNameView() {
        let songNameAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        songNameAnimation.fromValue = 0
        songNameAnimation.toValue = UIScreen.main.bounds.width
        songNameAnimation.repeatCount = .infinity
        songNameAnimation.fillMode = .both
        songNameAnimation.duration = player.duration / 4
        songNameAnimation.beginTime = CACurrentMediaTime() + 1
        songNameAnimation.isRemovedOnCompletion = false
        songNameAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        self.nameSongLabel.layer.add(songNameAnimation, forKey: "transformTranslationX")
    }
}

extension MediaPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        tapedNextSong(nextButton)
    }
}
