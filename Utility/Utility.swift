//
//  Utility.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/25.
//

import Foundation
import UIKit

class Utility {
    static func saveToUserDefaultsFavorite(movies: [Movie], _ viewController: UIViewController, _ message: String = "Movie added to favroites") {
        guard let moviesData = try? JSONEncoder().encode(movies)
        else {
            return
        }
        UserDefaults.standard.set(moviesData, forKey: "Favorites")
        showMessage(viewController, "Success!", message)
    }
    
    static func getFromUserDefaultsFavoriteMovies() -> [Movie]? {
        guard let moviesData = UserDefaults.standard.data(forKey: "Favorites"),
              let movies = try? JSONDecoder().decode([Movie].self, from: moviesData)
        else {
            return nil
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
