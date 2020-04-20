//
//  NetworkClient.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/20/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation

class NetworkClient {
    static var session: URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 60

        return URLSession(configuration: config)
    }
}
