//
//  ParsingTests.swift
//  MovieSearchTests
//
//  Created by Adam Rowe on 4/17/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import XCTest
@testable import MovieSearch

class ParsingTests: XCTestCase {
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

    func testMovieCanBeParsedFromCorrectData() throws {
        let movie = try? parseMovie("Movie")

        XCTAssertEqual(movie!.id, 343611)
        XCTAssertEqual(movie!.posterPath, "/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg")
        XCTAssertEqual(movie!.overview, "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.")
        XCTAssertEqual(movie!.title, "Jack Reacher: Never Go Back")
    }

    func testMovieCantBeParsedFromIncorrectData() throws {
        let movie = try? parseMovie("MalformattedMovie")

        XCTAssertNil(movie, "Malformatted Movie file")
    }
}
