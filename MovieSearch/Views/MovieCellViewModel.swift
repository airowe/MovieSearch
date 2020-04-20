//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/18/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

class MovieCellViewModel: UITableViewCell {
    static let identifier = "MovieCell"

    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var movieTitle: UILabel!

    func configure(with movie: Movie) {
        guard let posterPath = movie.poster_path else {
            return
        }
        
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
        moviePoster.loadImage(urlString: APIConfig.posterUrl + posterPath)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        movieTitle.sizeToFit()
        movieOverview.sizeToFit()
    }
}
