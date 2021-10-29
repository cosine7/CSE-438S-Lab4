//
//  API.swift
//  ChenXiaoLiu-Lab4
//
//  Created by lcx on 2021/10/28.
//

import Foundation

struct API {
    static let weeklyTrendsRequest = URL(
        string: "https://api.themoviedb.org/3/trending/movie/week?api_key=c4d21179571e64f8f5980962ac98eeb7"
    )
    
    static let dailyTrendsRequest = URL(
        string: "https://api.themoviedb.org/3/trending/movie/day?api_key=c4d21179571e64f8f5980962ac98eeb7"
    )
    
    static func getSearchRequest(_ page: Int, _ query: String) -> URL? {
        // Learned from https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.themoviedb.org"
        request.path = "/3/search/movie"
        request.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "api_key", value: "c4d21179571e64f8f5980962ac98eeb7"),
            URLQueryItem(name: "query", value: query)
        ]
        return request.url
    }
    // Learned from https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift
    static func GET<T>(_ request: URL?, _ type: T.Type, _ completion: @escaping (Result<T, FetchingError>) -> Void) where T: Decodable {
        guard let url = request,
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(type, from: data)
        else {
            completion(.failure(.unKnownError))
            return
        }
        completion(.success(response))
    }
}
