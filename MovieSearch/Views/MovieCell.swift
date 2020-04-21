//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/18/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"

    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!

    private var task: URLSessionDataTask?

    func configure(with movie: Movie) {
        guard let posterPath = movie.posterPath else {
            return
        }

        movieTitle.text = movie.title
        movieOverview.text = movie.overview

        if task == nil {
            task = moviePoster.loadImage(urlString: APIConfig.posterUrl + posterPath)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        task = nil

        moviePoster.image = nil
    }
}
