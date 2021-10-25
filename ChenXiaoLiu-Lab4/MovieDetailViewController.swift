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
}
