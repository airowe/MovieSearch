//
//  CustomFooterView.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

class CustomFooterView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        self.axis = .horizontal
        self.spacing = 8

        addArrangedSubview(footerImageView)
        addArrangedSubview(footerLabel)

        footerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    lazy var footerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tmdb"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36.0).isActive = true

        return imageView
    }()

    lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.thin)
        label.textAlignment = .justified

        return label
    }()
}
