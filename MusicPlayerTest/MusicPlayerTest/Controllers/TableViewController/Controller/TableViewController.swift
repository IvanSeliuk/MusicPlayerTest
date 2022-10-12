//
//  TableViewController.swift
//  MusicPlayerTest
//
//  Created by Иван Селюк on 6.10.22.
//

import UIKit

class TableViewController: UIViewController {
    
     let songs = Song.getSong()
    
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
    }
}



