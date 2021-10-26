//
//  FavoritesViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/25.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie]? = Utility.getFromUserDefaultsFavoriteMovies()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = movies {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        guard let textLabel = cell.textLabel,
              let detailLabel = cell.detailTextLabel,
              let items = movies
        else {
            return cell
        }
        textLabel.text = items[indexPath.row].title
        detailLabel.text = items[indexPath.row].overview
        return cell
    }
    
    // Learned from https://www.youtube.com/watch?v=F6dgdJCFS1Q
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete,
              var items = movies
        else {
            return
        }
        items.remove(at: indexPath.row)
        movies = items
        Utility.saveToUserDefaultsFavorite(movies: items, self, "Movie deleted from favroites")
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movies = Utility.getFromUserDefaultsFavoriteMovies()
        tableView.reloadData()
    }
}
