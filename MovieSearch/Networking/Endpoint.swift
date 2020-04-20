//
//  Endpoint.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/20/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation
import UIKit

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func search(matching query: String) -> Endpoint {
        return Endpoint(
            path: "/3/search/movie",
            queryItems: [
                URLQueryItem(name: "api_key", value: APIConfig.apiKey),
                URLQueryItem(name: "query", value: query)
            ]
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
