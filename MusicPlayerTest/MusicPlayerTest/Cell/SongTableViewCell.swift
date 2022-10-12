//
//  SongTableViewCell.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 7.10.22.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [songImage, songNameLabel, artistNameLabel].forEach { view in
            contentView.addSubview(view)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            songImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            songImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            songImage.widthAnchor.constraint(equalToConstant: 100),
            songImage.heightAnchor.constraint(equalToConstant: 100),
            songImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            songNameLabel.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 16),
            songNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            songNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: songImage.trailingAnchor, constant: 16),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 8),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            artistNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
            ])
    }
}
