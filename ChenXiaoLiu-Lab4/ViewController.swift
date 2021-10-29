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
    
    private let bottomSpinner = UIActivityIndicatorView()
    private var posterCache: [UIImage] = []
    private var isLoadingMovies = false
    private var movies: [Movie] = []
    private var currentPage = 0
    private var totalPage = 0
    private var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        spinner.center = self.view.center
        bottomSpinner.hidesWhenStopped = true
        bottomSpinner.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
        bottomSpinner.color = .black
    }
    
    // Learned from https://www.youtube.com/watch?v=iH67DkBx9Jc
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Learned from https://www.youtube.com/watch?v=FIXU6d370K8
        guard let queryItem = searchBar.text else { return }
        spinner.startAnimating()
        collectionView.alpha = 0.4
        query = queryItem
        DispatchQueue.global().async {
            self.currentPage = 1
            API.GET(API.getSearchRequest(self.currentPage, self.query), APIResults.self) { result in
                switch result {
                case .success(let apiResult):
                    self.movies = apiResult.results
                    self.posterCache = Utility.cachePosters(apiResult.results)
                    self.totalPage = apiResult.total_pages
                case .failure(_):
                    break
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.setContentOffset(.zero, animated: true)
                self.spinner.stopAnimating()
                self.collectionView.alpha = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Learned from https://www.youtube.com/watch?v=eWGu3hcL3ww
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        guard let cell = collectionCell as? CollectionViewCell
        else {
            return collectionCell
        }
        cell.label.text = movies[indexPath.item].title
        cell.imageView.image = posterCache[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Utility.pushMovieDetailViewController(self, movies[indexPath.item], posterCache[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind != UICollectionView.elementKindSectionFooter {
            return UICollectionReusableView()
        }
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "footer",
            for: indexPath
        )
        footer.addSubview(bottomSpinner)
        return footer
    }
    
    // Learned from https://www.youtube.com/watch?v=a1Agazw2JxM
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let addTofavorite = UIAction(
                title: "Add To Favorites",
                image: UIImage(named: "favorite")
            ) { _ in
                Utility.addToFavorite(self.movies[indexPath.item], self)
            }
            return UIMenu(
                title: self.movies[indexPath.item].title,
                children: [addTofavorite]
            )
        }
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Learned from https://stackoverflow.com/questions/6217900/uiscrollview-reaching-the-bottom-of-the-scroll-view
        let bottom = scrollView.contentOffset.y + scrollView.frame.size.height
        guard currentPage < totalPage,
              bottom > scrollView.contentSize.height,
              !isLoadingMovies
        else {
            return
        }
        isLoadingMovies = true
        bottomSpinner.startAnimating()
        DispatchQueue.global().async {
            self.currentPage += 1
            API.GET(API.getSearchRequest(self.currentPage, self.query), APIResults.self) {
                result in
                switch result {
                case .success(let apiResults):
                    self.movies.append(contentsOf: apiResults.results)
                    self.posterCache.append(contentsOf: Utility.cachePosters(apiResults.results))
                case .failure(_):
                    break
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.bottomSpinner.stopAnimating()
                self.isLoadingMovies = false
            }
        }
    }
}
