//
//  ViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/23.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var apiResults: APIResults?
    var posterCache: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    // Learned from https://www.youtube.com/watch?v=iH67DkBx9Jc
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.spinner.startAnimating()
        self.collectionView.alpha = 0.4
        guard let query = self.searchBar.text else { return }
        DispatchQueue.global().async {
            // Learned from https://www.youtube.com/watch?v=FIXU6d370K8
            guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?page=2&include_adult=false&api_key=c4d21179571e64f8f5980962ac98eeb7&query=\(query)"),
                  let data = try? Data(contentsOf: url),
                  let decodedData = try? JSONDecoder().decode(APIResults.self, from: data)
            else {
                return
            }
            self.apiResults = decodedData
            self.cachePosters()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
                self.collectionView.alpha = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let result = apiResults {
            return result.results.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Learned from https://www.youtube.com/watch?v=eWGu3hcL3ww
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell,
              let result = apiResults
        else {
            return UICollectionViewCell()
        }
        cell.label.text = result.results[indexPath.item].title
        cell.imageView.image = posterCache[indexPath.item]
        return cell
    }
    
    private func cachePosters() {
        guard let result = apiResults else { return }
        posterCache.removeAll()
        for movie in result.results {
            guard let posterPath = movie.poster_path,
                  let url = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else {
                posterCache.append(UIImage())
                continue
            }
            posterCache.append(image)
        }
    }
}
