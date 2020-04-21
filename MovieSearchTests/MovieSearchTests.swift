//
//  MovieSearchTests.swift
//  MovieSearchTests
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import XCTest
@testable import MovieSearch

class MovieSearchTests: XCTestCase {

    private var queryService: QueryService!

    override func setUp() {
        super.setUp()

        queryService = QueryService()
    }

    override func tearDown() {
        super.tearDown()

        queryService = nil
    }

    private func convertResponseToMovies(_ data: Data) -> [Movie] {
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            return decodedResponse.results.filter{ $0.posterPath != nil }
        } else { return [] }
    }

    private func searchMovies(for searchText: String,
                              then responseHandler: @escaping ([Movie]) -> Void) {

        queryService.request(.search(matching: searchText)) { result, _ in
            switch result {
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    responseHandler([Movie]())
                case .success(let response):
                    responseHandler(self.convertResponseToMovies(response))
            }
        }

    }

    func testInvalidQueryReturnsNoResults() {
        let searchText = "@"

        let expectation = self.expectation(description: "EmptyResults")

        var movies = [Movie]()

        searchMovies(for: searchText) { response in
            movies = response

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(movies.count, 0)
    }

    func testValidQueryReturnsResults() {
        let searchText = "Big"
        let expectation = self.expectation(description: "Results")

        var movies = [Movie]()

        searchMovies(for: searchText) { response in
            movies = response

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertGreaterThanOrEqual(movies.count, 0)
    }

    func testValidQueryHasSearchTermInAtLeastOneTitle() {
        let searchText = "Big"
        let expectation = self.expectation(description: "AtLeastOneResult")

        var movies = [Movie]()

        searchMovies(for: searchText) { response in
            movies = response

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5, handler: nil)

        let firstMovieWithTitle = movies.firstIndex{ $0.title.contains(searchText) }

        XCTAssertNotNil(firstMovieWithTitle, "No movies with title \(searchText)")
    }
}
