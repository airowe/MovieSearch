//
//  NetworkingError.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/20/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

enum NetworkingError: Error {
    case invalidURL
    case network(Error?)
}
