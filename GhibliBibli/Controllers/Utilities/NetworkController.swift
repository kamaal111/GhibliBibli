//
//  NetworkController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 02/02/2021.
//

import Foundation
import GhibliNet

class NetworkController {
    let ghibli = GhibliNet()

    private init() { }

    static let shared = NetworkController()
}
