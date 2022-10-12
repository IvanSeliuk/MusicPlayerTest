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

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
        cell.song = songs[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MusicPlayerViewController(songs: songs, index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

