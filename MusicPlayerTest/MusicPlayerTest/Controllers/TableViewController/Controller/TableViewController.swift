//
//  TableViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.10.22.
//

import UIKit

class TableViewController: UIViewController {
    
    let songs = Song.getSong()
    
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
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(SongTableViewCell.self, forCellReuseIdentifier: "SongTableViewCell")
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
        setupNavigationBar()
        setupSearchBar()
        animatedTableView()
    }
}
