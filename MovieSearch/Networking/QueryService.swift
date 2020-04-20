//
//  QueryService.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/17/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation

class QueryService {
    enum Result {
        case success(Data)
        case failure(NetworkingError)
    }

    var session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForResource = 60

        session = URLSession(configuration: config)
    }

    func request(_ endpoint: Endpoint,
                 then handler: @escaping (Result) -> Void) {
        guard let url = endpoint.url else {
            return handler(.failure(NetworkingError.invalidURL))
        }

        let task = session.dataTask(with: url) {
            data, _, error in

            let result = data.map(Result.success) ??
                        .failure(NetworkingError.network(error))

            handler(result)
        }

        task.resume()
    }
}
