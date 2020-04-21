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

    func loadImage(path: String) -> URLSessionDataTask? {

        if let imageFromCache = imageCache.object(forKey: path as AnyObject) as? UIImage {
            self.image = imageFromCache
            return nil
        }

        image = UIImage(named: "placeholder")

        let queryService = QueryService()

        let task = queryService.request(.image(at: path)) { result in
            switch result {
                case .failure:
                    return
                case .success(let response):
                    if let imageToCache = UIImage(data: response) {
                        imageCache.setObject(imageToCache, forKey: path as NSString)
                        DispatchQueue.main.async {
                            self.image = imageToCache
                        }
                    }
            }
        }

        task?.resume()

        return task
    }
}
