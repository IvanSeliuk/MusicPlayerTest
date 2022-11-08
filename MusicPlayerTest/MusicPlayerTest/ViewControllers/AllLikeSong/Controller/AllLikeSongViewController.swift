//
//  AllLikeSongViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 4.11.22.
//

import UIKit

class AllLikeSongViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredSong = [Song]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.reuseIdentifier)
        table.register(LikeSongsTableViewCell.self, forCellReuseIdentifier: LikeSongsTableViewCell.reuseIdentifier)
        table.backgroundColor = .clear
        return table
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "4d")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setupNavigationBar()
        setupSearchBar()
        animatedTableView()
    }
}
