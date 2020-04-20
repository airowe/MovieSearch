//
//  QueryService.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/17/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation

class QueryService {
    func request(_ endpoint: Endpoint,
                 then handler: @escaping (QueryResult) -> Void) {
        guard let url = endpoint.url else {
            return handler(.failure(NetworkingError.invalidURL))
        }

        let task = NetworkClient.session.dataTask(with: url) {
            data, _, error in

            let result = data.map(QueryResult.success) ??
                        .failure(NetworkingError.network(error))

            handler(result)
        }

        task.resume()
    }
}
