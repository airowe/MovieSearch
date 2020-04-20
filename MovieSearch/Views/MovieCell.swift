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

    func configure(with movie: Movie) {
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
        moviePoster.loadImage(urlString: APIConfig.posterUrl + movie.posterPath)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        movieTitle.sizeToFit()
        movieOverview.sizeToFit()
    }
}
