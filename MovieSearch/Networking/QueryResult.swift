//
//  QueryResult.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/20/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation

enum QueryResult {
    case success(Data)
    case failure(NetworkingError)
}
