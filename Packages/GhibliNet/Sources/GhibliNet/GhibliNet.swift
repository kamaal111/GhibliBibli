//
//  GhibliNet.swift
//  
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import Foundation
import ShrimpExtensions

public struct GhibliNet {
    public init() { }

    public func getFilms() -> Result<[GhibliFilm], Error> {
        guard let path = Bundle.module.path(forResource: "films", ofType: "json") else {
            return .failure(GhibliNet.Errors.resourceNotFound)
        }
        let films: Result<[GhibliFilm], Error> = URL(fileURLWithPath: path).getJSON()
        return films
    }

    public func getImagePath(withName imageName: String) -> String? {
        Bundle.module.path(forResource: imageName, ofType: nil)
    }

    enum Errors: Error {
        case resourceNotFound
    }
}

extension GhibliNet.Errors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return "Resourse could not be found"
        }
    }
}
