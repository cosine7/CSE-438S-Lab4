//
//  ReviewAPIResults.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/29.
//

import Foundation

struct ReviewAPIResults: Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Review]
}
