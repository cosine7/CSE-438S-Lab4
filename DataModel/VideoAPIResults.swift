//
//  VideoAPIResults.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/25.
//

struct VideoAPIResults: Decodable {
    let id: Int!
    let results: [Video]
}
