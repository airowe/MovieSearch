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
                 then responseHandler: @escaping (QueryResult, URLSessionDataTask?) -> Void) {
        guard let url = endpoint.url else {
            return responseHandler(.failure(NetworkingError.invalidURL), nil)
        }

        var task: URLSessionDataTask?

        task = NetworkClient.session.dataTask(with: url) {
            data, _, error in

            let result = data.map(QueryResult.success) ??
                        .failure(NetworkingError.network(error))

            responseHandler(result, task)
        }

        task?.resume()
    }
}
