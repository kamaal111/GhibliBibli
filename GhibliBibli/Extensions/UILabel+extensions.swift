//
//  UILabel+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 04/02/2021.
//

import UIKit

extension UILabel {
    static func sectionHeader(text: String) -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.text = text
        return label
    }

    static func filmTitleLabel(title: String?) -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.text = title
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }
}
