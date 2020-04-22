//
//  EndpointTest.swift
//  MovieSearchTests
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import XCTest
@testable import MovieSearch

class EndpointTest: XCTestCase {
    private var movie: Movie!

    override func setUp() {
        super.setUp()

        movie = try? parseMovie("Movie")
    }

    override func tearDown() {
        super.tearDown()

        movie = nil
    }

    func testSearchEndpointCreatedSuccessfully() {
        let searchText = "Big"
        let endpoint = Endpoint.search(matching: searchText)

        XCTAssertEqual(endpoint.url, URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(Endpoint.apiKey)&query=Big"))
    }

    func testImageEndpointCreatedSuccessfully() throws {
        guard let path = movie.posterPath else {
            XCTFail("nil Movie Poster Path")
            return
        }

        let endpoint = Endpoint.image(at: path)

        XCTAssertEqual(endpoint.url, URL(string: "https://image.tmdb.org/t/p/w600_and_h900_bestv2\(path)"))
    }

    private func parseMovie(_ filename: String) throws -> Movie? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            XCTFail("Missing file: Movie.json")
            return nil
        }

        let json = try Data(contentsOf: url)
        let movie = try? JSONDecoder().decode(Movie.self, from: json)

        return movie
    }

}
