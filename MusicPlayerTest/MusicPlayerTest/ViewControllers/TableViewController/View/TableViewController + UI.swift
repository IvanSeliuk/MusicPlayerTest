//
//  TableViewController + UI.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 12.10.22.
//

import UIKit
import Firebase

extension TableViewController {
    
    func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "My Music"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 30)!]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.square",
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)),
            style: .plain,
            target: self,
            action: #selector(signOutAction))
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search music", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "ColorSearch")
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.tintColor = .white
        definesPresentationContext = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func signOutAction() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

//MARK: - TableViewDelegate

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 108
        case 1: return 250
        default: return 0
        }
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return isFiltering ? filteredSong.count : songs.count
        case 1: return 1
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
            
            cell.song = isFiltering ? filteredSong[indexPath.row] : songs[indexPath.row]
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeSongsTableViewCell.reuseIdentifier, for: indexPath) as? LikeSongsTableViewCell else { return UITableViewCell() }
            
            cell.userClickLikedSong = { [unowned self] indexSong in
                let vc = MusicPlayerViewController(songs: self.songs , index: indexSong)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.userClickButtonShowAll = { [weak self] in
                let vc = AllLikeSongViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        default: return UITableViewCell()
        }
    }
    
    func animatedTableView() {
        tableView.reloadData()
        let cells = tableView.visibleCells as? [SongTableViewCell]
        var delay: Double = 0
        if let str = cells {
            for cell in str {
                cell.transform = CGAffineTransform(translationX: 0,
                                                   y: tableView.bounds.height)
                UIView.animate(withDuration: 1.5,
                               delay: delay * 0.05,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0,
                               options: .curveEaseInOut) {
                    cell.transform = CGAffineTransform.identity
                }
                delay += 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        if isFiltering {
            let vc = MusicPlayerViewController(songs: filteredSong, index: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = MusicPlayerViewController(songs: songs, index: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - SearchController

extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredSong = songs.filter({ songs in
            return songs.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
