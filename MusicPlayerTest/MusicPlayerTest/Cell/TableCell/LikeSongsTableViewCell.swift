//
//  LikeSongsTableViewCell.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 29.10.22.
//

import UIKit

class LikeSongsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "LikeSongsTableViewCell"
    static let shared = LikeSongsTableViewCell()
    var likedSongs: [Song] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var userClickLikedSong: ((Int) -> ())?
    var userClickButtonShowAll: (() -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var likedSongLabel: UILabel = {
        let label = UILabel()
        label.text = "Liked songs"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var showAllLabel: UILabel = {
        let label = UILabel()
        label.text = "Show all"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private lazy var showAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showAllButtonAction), for: .touchUpInside)
        return button
    }()
    
    @objc private func showAllButtonAction() {
        userClickButtonShowAll?()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.reuseIdentifier)
        
        return collection
    }()
    
    private func setupView() {
        [viewCell, showAllLabel, showAllButton, likedSongLabel, collectionView].forEach { view in
            contentView.addSubview(view)
        }
        setupConstraints()
        likedSongs = CoreDataManager.shared.getLikedSongs()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewCell.topAnchor.constraint(equalTo: topAnchor),
            viewCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewCell.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        NSLayoutConstraint.activate([
            likedSongLabel.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor, constant: 16),
            likedSongLabel.centerYAnchor.constraint(equalTo: viewCell.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            showAllLabel.centerYAnchor.constraint(equalTo: viewCell.centerYAnchor),
            showAllLabel.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            showAllButton.leadingAnchor.constraint(equalTo: viewCell.leadingAnchor),
            showAllButton.topAnchor.constraint(equalTo: viewCell.topAnchor),
            showAllButton.trailingAnchor.constraint(equalTo: viewCell.trailingAnchor),
            showAllButton.bottomAnchor.constraint(equalTo: viewCell.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: viewCell.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//MARK: - CollectionViewDelegate

extension LikeSongsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 220.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userClickLikedSong?(indexPath.item)
    }
}

extension LikeSongsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCollectionViewCell.reuseIdentifier, for: indexPath) as? SongCollectionViewCell else { return UICollectionViewCell() }
        cell.song = likedSongs[indexPath.item]
        cell.backgroundColor = .clear
        return cell
    }
}
