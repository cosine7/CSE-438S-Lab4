//
//  TrendingViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/27.
//

import UIKit

class TrendingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var weeklyTrendsCollectionView: UICollectionView!
    @IBOutlet weak var dailyTrendsCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private var weelyMovies: [Movie] = []
    private var dailyMovies: [Movie] = []
    private var weeklyPosterCache: [UIImage] = []
    private var dailyPosterCache: [UIImage] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyTrendsCollectionView.delegate = self
        weeklyTrendsCollectionView.dataSource = self
        dailyTrendsCollectionView.delegate = self
        dailyTrendsCollectionView.dataSource = self
        spinner.center = view.center
        spinner.startAnimating()
        DispatchQueue.global().async {
            API.GET(API.weeklyTrendsRequest) {
                result in
                switch result {
                case .success(let apiResult):
                    self.weelyMovies = apiResult.results
                    self.weeklyPosterCache = Utility.cachePosters(apiResult.results)
                case .failure(_):
                    break
                }
            }
            API.GET(API.dailyTrendsRequest) {
                result in
                switch result {
                case .success(let apiResult):
                    self.dailyMovies = apiResult.results
                    self.dailyPosterCache = Utility.cachePosters(apiResult.results)
                case .failure(_):
                    break
                }
            }
            DispatchQueue.main.async {
                self.weeklyTrendsCollectionView.reloadData()
                self.dailyTrendsCollectionView.reloadData()
                self.spinner.stopAnimating()
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weeklyTrendsCollectionView {
            return weelyMovies.count
        }
        return dailyMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        guard let cell = collectionCell as? CollectionViewCell
        else {
            return collectionCell
        }
        cell.label.text = collectionView == weeklyTrendsCollectionView
            ? weelyMovies[indexPath.item].title
            : dailyMovies[indexPath.item].title
        cell.imageView.image = collectionView == weeklyTrendsCollectionView
            ? weeklyPosterCache[indexPath.item]
            : dailyPosterCache[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = collectionView == weeklyTrendsCollectionView
            ? weelyMovies[indexPath.item]
            : dailyMovies[indexPath.item]
        let poster = collectionView == weeklyTrendsCollectionView
            ? weeklyPosterCache[indexPath.item]
            : dailyPosterCache[indexPath.item]
        
        Utility.pushMovieDetailViewController(self, movie, poster)
    }
}
