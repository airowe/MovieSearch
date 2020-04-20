//
//  UIViewExtension.swift
//  MovieSearch
//
//  Created by Adam Rowe on 4/20/20.
//  Copyright © 2020 Adam Rowe. All rights reserved.
//

import UIKit

extension UIView {

    func isHiddenWithAnimation(_ hidden: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
}
