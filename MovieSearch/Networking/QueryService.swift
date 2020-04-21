//
//  QueryService.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/17/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation

class QueryService {

    @discardableResult
    func request(_ endpoint: Endpoint,
                 then responseHandler: @escaping (QueryResult) -> Void) -> URLSessionDataTask? {
        guard let url = endpoint.url else {
            responseHandler(.failure(NetworkingError.invalidURL))
            return nil
        }

        let task = NetworkClient.session.dataTask(with: url) {
            data, _, error in

            let result = data.map(QueryResult.success) ??
                        .failure(NetworkingError.network(error))

            responseHandler(result)
        }

        task.resume()

        return task
    }
}
