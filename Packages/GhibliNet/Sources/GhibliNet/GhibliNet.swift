//
//  GhibliNet.swift
//  
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import XiphiasNet
import Foundation
import ShrimpExtensions

public struct GhibliNet {
    public let baseURL = URL(staticString: "https://ghibliapi.herokuapp.com")

    private let networker: XiphiasNetable = XiphiasNet()

    public init() { }

    public func getFilms(completion: @escaping (Result<[GhibliFilm], Error>) -> Void) {
        let callURL = baseURL
            .appendingPathComponent("films")
        networker.request(from: callURL, completion: completion)
    }
}
