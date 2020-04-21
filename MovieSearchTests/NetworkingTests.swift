//
//  NetworkingTests.swift
//  MovieSearchTests
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import XCTest
@testable import MovieSearch

class NetworkingTests: XCTestCase {

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

    func testInvalidQueryReturnsNoResults() {
        let searchText = "@"

        let expectation = self.expectation(description: "EmptyResults")

        var searchResults:[Movie] = []

        queryService.request(.search(matching: searchText)) { result in
            switch result {
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    searchResults.removeAll()
                    expectation.fulfill()
                case .success(let response):
                    searchResults = self.convertResponseToMovies(response)
                    expectation.fulfill()
            }
        }

        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(searchResults.count, 0)
    }

    func testValidQueryReturnsResults() {
        let searchText = "Big"

        let expectation = self.expectation(description: "Results")

        var searchResults:[Movie] = []

        queryService.request(.search(matching: searchText)) { result in
            switch result {
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    searchResults.removeAll()
                    expectation.fulfill()
                case .success(let response):
                    searchResults = self.convertResponseToMovies(response)
                    expectation.fulfill()
            }
        }

        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertGreaterThanOrEqual(searchResults.count, 0)
    }

    func testValidQueryHasSearchTermInAtLeastOneTitle() {
        let searchText = "Big"
        let expectation = self.expectation(description: "AtLeastOneResult")

        var searchResults:[Movie] = []

        queryService.request(.search(matching: searchText)) { result in
            switch result {
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    searchResults.removeAll()
                    expectation.fulfill()
                case .success(let response):
                    searchResults = self.convertResponseToMovies(response)
                    expectation.fulfill()
            }
        }

        self.waitForExpectations(timeout: 5, handler: nil)

        let firstMovieWithTitle = searchResults.first{ $0.title.contains(searchText) }

        XCTAssertNotNil(firstMovieWithTitle, "No movies with title \(searchText)")
    }
}
