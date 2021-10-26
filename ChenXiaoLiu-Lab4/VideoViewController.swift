//
//  VideoViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/25.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {
    @IBOutlet weak var videoView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        DispatchQueue.global().async {
            guard let id = self.movieId,
                  let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=c4d21179571e64f8f5980962ac98eeb7"),
                  let data = try? Data(contentsOf: url),
                  let response = try? JSONDecoder().decode(VideoAPIResults.self, from: data),
                  response.results.count > 0,
                  let key = response.results[0].key,
                  let youtubeURL = URL(string: "https://www.youtube.com/embed/\(key)")
            else {
                DispatchQueue.main.async {
                    Utility.showMessage(self, "Sorry", "This Movie does not have a trailer", self.handleNoTrailer)
                    self.spinner.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                self.videoView.load(URLRequest(url: youtubeURL))
                self.spinner.stopAnimating()
            }
        }
    }
    
    @objc func handleNoTrailer(_ alert: UIAlertAction) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
