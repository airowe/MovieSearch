//
//  Util.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import Foundation

public class Util {
    static func convertResponseToMovies(_ data: Data) -> [Movie] {
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            return decodedResponse.results.filter{ $0.posterPath != nil }
        } else { return [] }
    }
}
