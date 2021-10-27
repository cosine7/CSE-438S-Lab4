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
    private var apiResults: APIResults?
    private var posterCache: [UIImage] = []
    private var isLoadingMovies = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        spinner.center = self.view.center
    }
    
    // Learned from https://www.youtube.com/watch?v=iH67DkBx9Jc
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Learned from https://www.youtube.com/watch?v=FIXU6d370K8
        self.spinner.startAnimating()
        self.collectionView.alpha = 0.4
        guard let query = self.searchBar.text else { return }
        DispatchQueue.global().async {
            // Learned from https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
            var request = URLComponents()
            request.scheme = "https"
            request.host = "api.themoviedb.org"
            request.path = "/3/search/movie"
            request.queryItems = [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: "c4d21179571e64f8f5980962ac98eeb7"),
                URLQueryItem(name: "query", value: query)
            ]
            guard let url = request.url,
                  let data = try? Data(contentsOf: url),
                  let response = try? JSONDecoder().decode(APIResults.self, from: data)
            else {
                return
            }
            self.apiResults = response
            self.posterCache = Utility.cachePosters(response.results)

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
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath)
        guard let cell = collectionCell as? CollectionViewCell,
              let result = apiResults
        else {
            return collectionCell
        }
        cell.label.text = result.results[indexPath.item].title
        cell.imageView.image = posterCache[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let result = apiResults else { return }
        Utility.pushMovieDetailViewController(self, result.results[indexPath.item], posterCache[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("success")
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterCollectionReusableView.identifier,
            for: indexPath
        )
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Learned from https://stackoverflow.com/questions/6217900/uiscrollview-reaching-the-bottom-of-the-scroll-view
        let bottom = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottom <= scrollView.contentSize.height {
            return
        }
//        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier, for: <#T##IndexPath#>)
//        footer.spinner.startAnimating()
    }
}
