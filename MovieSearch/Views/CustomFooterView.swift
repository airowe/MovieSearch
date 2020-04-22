//
//  CustomFooterView.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/21/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

class CustomFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        containerStackView.addArrangedSubview(footerImageView)
        containerStackView.addArrangedSubview(footerLabel)

        footerImageView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor).isActive = true
        footerLabel.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor).isActive = true
    }

    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true

        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        return stackView
    }()

    lazy var footerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tmdb"))
        imageView.contentMode = .scaleAspectFit

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
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
}
