//
//  SongCollectionViewCell.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 26.10.22.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SongCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var song: Song? {
        didSet {
            if let song {
                songImage.image = UIImage(named: song.image)
                songNameLabel.text = song.name
                artistNameLabel.text = song.artist
            }
        }
    }
    
    private lazy var viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var songImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        return image
    }()
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [viewCell, songImage, songNameLabel, artistNameLabel].forEach { views in
            addSubview(views)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            viewCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewCell.topAnchor.constraint(equalTo: topAnchor),
            viewCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewCell.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            songImage.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 8),
            songImage.topAnchor.constraint(equalTo: viewCell.topAnchor, constant: 8),
            songImage.widthAnchor.constraint(equalToConstant: 164),
            songImage.heightAnchor.constraint(equalToConstant: 169.67),
            songImage.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -8),
            songImage.bottomAnchor.constraint(equalTo: songNameLabel.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            songNameLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 8),
            songNameLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -8),
            songNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: 2)
            ])
        songNameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        songNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            artistNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        artistNameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        artistNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}

    

