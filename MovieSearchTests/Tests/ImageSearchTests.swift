//
//  ImageSearchTests.swift
//  MovieSearchTests
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import XCTest
@testable import MovieSearch

class ImageSearchTests: XCTestCase {
    private var movie: Movie!
    private var queryService: QueryService!

    override func setUp() {
        super.setUp()

        try? movie = parseMovie()

        queryService = QueryService()
    }

    override func tearDown() {
        super.tearDown()

        movie = nil
        queryService = nil
    }

    private func parseMovie() throws -> Movie? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Movie", withExtension: "json") else {
            XCTFail("Missing file: Movie.json")
            return nil
        }

        let json = try Data(contentsOf: url)
        let movie = try? JSONDecoder().decode(Movie.self, from: json)

        return movie
    }

    private func searchImages(for path: String,
                              then responseHandler: @escaping (UIImage?) -> Void) {
        queryService.request(.image(at: path)) { result in
            switch result {
                case .failure:
                    responseHandler(nil)
                case .success(let response):
                    if let image = UIImage(data: response) {
                        responseHandler(image)
                    } else {
                        responseHandler(nil)
                    }
            }
        }
    }

    func testImageExistsForValidPath() {
        let expectation = self.expectation(description: "ImageExists")

        var searchedImage:UIImage?

        searchImages(for: movie.posterPath!) { response in
            searchedImage = response

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(searchedImage)
    }

    func testImageDoesNotExistForInvalidPath() {
        let expectation = self.expectation(description: "ImageDoesNotExist")

        var searchedImage:UIImage?

        searchImages(for: "notAGoodPath") { response in
            searchedImage = response

            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(searchedImage)
    }
}
