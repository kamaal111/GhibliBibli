//
//  UIImageView+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 04/02/2021.
//

import UIKit

extension UIImageView {
    static func filmImageView(image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.shadowColor = UIColor.accentColor.cgColor
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.shadowRadius = 4
        imageView.clipsToBounds = false
        imageView.image = image
        return imageView
    }
}
