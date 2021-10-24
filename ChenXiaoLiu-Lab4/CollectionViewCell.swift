//
//  CollectionViewCell.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/23.
//

import UIKit


// https://www.youtube.com/watch?v=eWGu3hcL3ww&t=938s
class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    static let identifier = "CollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
