//
//  ReviewsViewController.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/29.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movieId: Int?
    private var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.global().async {
            guard let id = self.movieId
            else {
                return
            }
            API.GET(
                URL(string: "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=c4d21179571e64f8f5980962ac98eeb7"),
                ReviewAPIResults.self) { result in
                switch result {
                case .success(let reviewAPIResults):
                    self.reviews = reviewAPIResults.results
                case .failure(_):
                    break
                }
            }
            DispatchQueue.main.async {
                if self.reviews.count == 0 {
                    Utility.showMessage(
                        self, "Sorry", "This Movie does not have any reviews",
                        { _ in self.dismiss(animated: true) }
                    )
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        guard let cell = tableCell as? TableViewCell
        else {
            return tableCell
        }
        cell.author.text = reviews[indexPath.row].author
        cell.review.text = reviews[indexPath.row].content
        return cell
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
