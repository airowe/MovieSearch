//
//  UIImageViewExtension.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/18/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImage(urlString: String) -> URLSessionDataTask? {

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return nil
        }

        guard let url = URL(string: urlString) else {
            return nil
        }

        image = UIImage(named: "placeholder")

        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, _, error in

            DispatchQueue.main.async {
                if let data = data, let imageToCache = UIImage(data: data) {
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    self?.image = imageToCache
                }
            }
        }

        task.resume()

        return task
    }
}
