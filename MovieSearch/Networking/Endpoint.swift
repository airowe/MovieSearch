//
//  Endpoint.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/20/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation
import UIKit

private enum RequestType {
    case image
    case search
}

public struct Endpoint {
    static let apiKey = ProcessInfo.processInfo.environment["api_key"]
    let path: String
    var queryItems: [URLQueryItem]? = [URLQueryItem]()
    private var type: RequestType

    var url: URL? {
        switch type {
            case .image:
                var components = URLComponents()
                components.scheme = "https"
                components.host = "image.tmdb.org"
                components.path = path
                return components.url

            case .search:
                var components = URLComponents()
                components.scheme = "https"
                components.host = "api.themoviedb.org"
                components.path = path
                components.queryItems = queryItems
                return components.url
        }
    }
}

extension Endpoint {
    static func image(at path: String) -> Endpoint {
        return Endpoint(
            path: "/t/p/w600_and_h900_bestv2\(path)",
            type: .image
        )
    }

    static func search(matching query: String) -> Endpoint {
        return Endpoint(
            path: "/3/search/movie",
            queryItems: [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "query", value: query)
            ],
            type: .search
        )
    }
}
