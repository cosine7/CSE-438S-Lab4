//
//  MovieDetailViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var poster: UIImage?
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = self.movie else { return }
        releaseDate.text = item.release_date ?? "Unknown"
        imageView.image = poster
        score.text = "\(item.vote_average) / 10"
        overview.text = item.overview == "" ? "Sorry, no overview for this movie" : item.overview
    }
    
    @IBAction func watchTrailerButtonClicked(_ sender: Any) {
        guard let item = movie,
              let navController = self.navigationController,
              let videoViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController
        else {
            return
        }
        videoViewController.movieId = item.id
        navController.pushViewController(videoViewController, animated: true)
    }
    
    @IBAction func addToFavoriteButtonPressed(_ sender: Any) {
//        // Learned from https://stackoverflow.com/questions/28240848/how-to-save-an-array-of-objects-to-nsuserdefault-with-swift
        guard let item = movie else { return }
        Utility.addToFavorite(item, self)
//        var movies = Utility.getFromUserDefaultsFavoriteMovies()
//        movies.append(item)
//        Utility.saveToUserDefaultsFavorite(movies: movies, self)
    }
}
