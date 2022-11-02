//
//  SongTableViewCell.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 7.10.22.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SongTableViewCell"
    var song: Song? {
        didSet {
            if let song {
                songImage.image = UIImage(named: song.image)
                songNameLabel.text = song.name
                artistNameLabel.text = song.artist
            }
        }
    }
    
    private lazy var songImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "arrow")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [songImage, songNameLabel, artistNameLabel, arrowImage].forEach { view in
            addSubview(view)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            songImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            songImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            songImage.widthAnchor.constraint(equalToConstant: 100),
            songImage.heightAnchor.constraint(equalToConstant: 100),
            songImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            songNameLabel.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 16),
            songNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 16),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8),
            artistNameLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: 0),
            artistNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
            ])
        
        NSLayoutConstraint.activate([
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImage.centerYAnchor.constraint(equalTo: songImage.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 12),
            arrowImage.heightAnchor.constraint(equalToConstant: 12),
            ])
    }
}
