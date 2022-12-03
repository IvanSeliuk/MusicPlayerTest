//
//  AllLikeSongViewController + Ui.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 4.11.22.
//

import UIKit

extension AllLikeSongViewController {
    func setupView() {
        view.addSubview(backgroundImage)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "My liked music"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 25)!]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.backward.fill",
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)),
            style: .plain,
            target: self,
            action: #selector(backMyMusic))
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
    
    @objc private func backMyMusic() {
        let vc = TableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TableViewDelegate

extension AllLikeSongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 108
        case 1: return 250
        default: return 0
        }
    }
}

extension AllLikeSongViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredSong.count : LikeSongsTableViewCell.shared.likedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
        cell.song = isFiltering ? filteredSong[indexPath.row] : LikeSongsTableViewCell.shared.likedSongs[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func animatedTableView() {
        tableView.reloadData()
        let cells = tableView.visibleCells as! [SongTableViewCell]
        var delay: Double = 0
        for cell in cells {
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
    
    private func animationPushViewController(to vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.75
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        if isFiltering {
            let vc = MusicPlayerViewController(songs: filteredSong, index: indexPath.row)
            animationPushViewController(to: vc)
        } else {
            let vc = MusicPlayerViewController(songs: LikeSongsTableViewCell.shared.likedSongs, index: indexPath.row)
            animationPushViewController(to: vc)
        }
    }
}

//MARK: - SearchController

extension AllLikeSongViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredSong = LikeSongsTableViewCell.shared.likedSongs.filter({ songs in
            return songs.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
