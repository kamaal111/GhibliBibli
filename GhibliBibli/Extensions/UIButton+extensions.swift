//
//  UIButton+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 04/02/2021.
//

import UIKit

extension UIButton {
    static func filmCharacterButton(containerViewSize: CGSize, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.contentHorizontalAlignment = .leading
        let chevronRightImage = UIImage(systemName: "chevron.right")
        button.setImage(chevronRightImage, for: .normal)
        let chevronRightImageWidth = chevronRightImage?.size.width ?? 0
        button.titleEdgeInsets.left = -chevronRightImageWidth
        /// - TODO: Make sure this gets updated after orientation changes
        button.imageEdgeInsets.left = containerViewSize.width - chevronRightImageWidth - 32
        button.contentEdgeInsets.right = -containerViewSize.width
        return button
    }
}
