//
//  FavoritesViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/25.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = Utility.getFromUserDefaultsFavoriteMovies() {
        didSet {
            DispatchQueue.global().async {
                self.posterCache = Utility.cachePosters(self.movies)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    var posterCache: [UIImage] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let textLabel = cell.textLabel,
              let detailLabel = cell.detailTextLabel,
              let imageView = cell.imageView
        else {
            return cell
        }
        textLabel.text = movies[indexPath.row].title
        detailLabel.text = movies[indexPath.row].overview
        if indexPath.row < posterCache.count {
            imageView.image = posterCache[indexPath.row]
        }
        return cell
    }
    
    // Learned from https://www.youtube.com/watch?v=F6dgdJCFS1Q
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movies.remove(at: indexPath.row)
            Utility.saveToUserDefaultsFavorite(movies: movies, self, "Movie deleted from favroites")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utility.pushMovieDetailViewController(self, movies[indexPath.row], posterCache[indexPath.row])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            self.movies = Utility.getFromUserDefaultsFavoriteMovies()
        }
    }
}
