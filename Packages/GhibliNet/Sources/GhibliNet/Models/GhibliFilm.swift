//
//  GhibliFilm.swift
//  
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import Foundation

public struct GhibliFilm: Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let director: String
    public let producer: String
    public let releaseDate: String
    public let rtScore: String
    public let people: [URL]
    public let species: [URL]
    public let locations: [URL]
    public let url: URL
    public let vehicles: [URL]

    public init(id: UUID,
                title: String,
                description: String,
                director: String,
                producer: String,
                releaseDate: String,
                rtScore: String,
                people: [URL],
                species: [URL],
                locations: [URL],
                url: URL,
                vehicles: [URL]) {
        self.id = id
        self.title = title
        self.description = description
        self.director = director
        self.producer = producer
        self.releaseDate = releaseDate
        self.rtScore = rtScore
        self.people = people
        self.species = species
        self.locations = locations
        self.url = url
        self.vehicles = vehicles
    }

    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case director
        case producer
        case releaseDate = "release_date"
        case rtScore = "rt_score"
        case people
        case species
        case locations
        case url
        case vehicles
    }
}
