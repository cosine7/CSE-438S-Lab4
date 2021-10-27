//
//  Utility.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/25.
//

import Foundation
import UIKit

class Utility {
    static func cachePosters( _ movies: [Movie]) -> [UIImage] {
        guard let posterNotAvailable = UIImage(named: "noImage")
        else {
            return []
        }
        var posterCache: [UIImage] = []
        
        for movie in movies {
            guard let posterPath = movie.poster_path,
                  let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)"),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else {
                posterCache.append(posterNotAvailable)
                continue
            }
            posterCache.append(image)
        }
        return posterCache
    }
    
    static func pushMovieDetailViewController(_ viewController: UIViewController, _ movie: Movie, _ poster: UIImage) {
        guard let navController = viewController.navigationController,
              let movieDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
        else {
            return
        }
        movieDetailViewController.poster = poster
        movieDetailViewController.movie = movie
        navController.pushViewController(movieDetailViewController, animated: true)
    }
    
    static func saveToUserDefaultsFavorite(movies: [Movie], _ viewController: UIViewController, _ message: String = "Movie added to favroites") {
        guard let moviesData = try? JSONEncoder().encode(movies)
        else {
            return
        }
        UserDefaults.standard.set(moviesData, forKey: "Favorites")
        showMessage(viewController, "Success!", message)
    }
    
    static func getFromUserDefaultsFavoriteMovies() -> [Movie] {
        guard let moviesData = UserDefaults.standard.data(forKey: "Favorites"),
              let movies = try? JSONDecoder().decode([Movie].self, from: moviesData)
        else {
            return []
        }
        return movies
    }
    
    static func showMessage(_ viewController: UIViewController, _ title: String, _ content: String, _ handler: ((UIAlertAction) -> Void)? = nil) {
        let message = UIAlertController(
            title: title,
            message: content,
            preferredStyle: .alert
        )
        message.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: handler
            )
        )
        viewController.present(message, animated: true)
    }
}
