//
//  GhibliPeople.swift
//  
//
//  Created by Kamaal M Farah on 01/02/2021.
//

import Foundation

public struct GhibliPeople: Codable, Hashable, Identifiable {
    public let id: UUID
    public let name: String
    public let gender: String
    public let eyeColor: HexColorName
    public let hairColor: HexColorName
    public let films: [UUID]
    public let species: UUID
    public let age: String?

    public init(id: UUID,
                name: String,
                gender: String,
                eyeColor: HexColorName,
                hairColor: HexColorName,
                films: [UUID],
                species: UUID,
                age: String?) {
        self.id = id
        self.name = name
        self.gender = gender
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        self.films = films
        self.species = species
        self.age = age
    }

    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case films
        case species
        case age
    }

    public struct HexColorName: Codable, Hashable {
        public let name: String
        public let hex: String?

        public init(name: String, hex: String?) {
            self.name = name
            self.hex = hex
        }
    }
}
