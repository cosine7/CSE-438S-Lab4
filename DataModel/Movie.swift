//
//  Movie.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/23.
//

struct Movie: Codable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int!
}
