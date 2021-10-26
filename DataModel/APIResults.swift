//
//  APIResults.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/23.
//

struct APIResults: Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
