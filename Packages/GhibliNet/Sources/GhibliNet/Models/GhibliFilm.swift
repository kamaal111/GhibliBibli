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
    public let originalTitle: String
    public let originalTitleRomanised: String
    public let description: String
    public let director: String
    public let producer: String
    public let releaseDate: Int
    public let runningTime: Int
    public let rtScore: Int
    public let people: [UUID]
    public let species: [UUID]
    public let locations: [UUID]
    public let vehicles: [UUID]
    public let imageUrl: URL

    public init(id: UUID,
                title: String,
                originalTitle: String,
                originalTitleRomanised: String,
                description: String,
                director: String,
                producer: String,
                releaseDate: Int,
                runningTime: Int,
                rtScore: Int,
                people: [UUID],
                species: [UUID],
                locations: [UUID],
                vehicles: [UUID],
                imageUrl: URL) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalTitleRomanised = originalTitleRomanised
        self.description = description
        self.director = director
        self.producer = producer
        self.releaseDate = releaseDate
        self.runningTime = runningTime
        self.rtScore = rtScore
        self.people = people
        self.species = species
        self.locations = locations
        self.vehicles = vehicles
        self.imageUrl = imageUrl
    }

    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case originalTitleRomanised = "original_title_romanised"
        case description
        case director
        case producer
        case releaseDate = "release_date"
        case runningTime = "running_time"
        case rtScore = "rt_score"
        case people
        case species
        case locations
        case vehicles
        case imageUrl = "image_url"
    }
}
