//
//  FooterCollectionReusableView.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/27.
//

import UIKit

// Learned from https://www.youtube.com/watch?v=ofq11PBWNeQ
class FooterCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    static let identifier = "FooterCollectionReusableView"
}
