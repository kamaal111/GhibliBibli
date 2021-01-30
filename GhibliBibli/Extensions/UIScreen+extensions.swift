//
//  UIScreen+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 30/01/2021.
//

import UIKit

extension UIScreen {
    var narrowestEdge: CGFloat {
        let screenWidth = self.bounds.width
        let screenHeight = self.bounds.height
        if screenWidth > screenHeight {
            return screenHeight
        }
        return screenWidth
    }

    var widestEdge: CGFloat {
        let screenWidth = self.bounds.width
        let screenHeight = self.bounds.height
        if screenWidth < screenHeight {
            return screenHeight
        }
        return screenWidth
    }
}
