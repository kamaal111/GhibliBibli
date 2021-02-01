//
//  GhibliNet.swift
//  
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import Foundation
import ShrimpExtensions

public class GhibliNet {

    private var people: [GhibliPeople] = []
    private var films: [GhibliFilm] = []
    private var filmPeople: [UUID: [GhibliPeople]] = [:]

    public init() { }

    public func getFilms() -> Result<[GhibliFilm], Error> {
        guard films.isEmpty else { return .success(films) }
        guard let path = Bundle.module.path(forResource: "films", ofType: "json") else {
            return .failure(GhibliNet.Errors.resourceNotFound)
        }
        let filmsResult: Result<[GhibliFilm], Error> = URL(fileURLWithPath: path).getJSON()
        switch filmsResult {
        case .failure(let failure):
            return .failure(failure)
        case .success(let success):
            films = success
            return .success(success)
        }
    }

    public func getPeople() -> Result<[GhibliPeople], Error> {
        guard people.isEmpty else { return .success(people) }
        guard let path = Bundle.module.path(forResource: "people", ofType: "json") else {
            return .failure(GhibliNet.Errors.resourceNotFound)
        }
        let peopleResult: Result<[GhibliPeople], Error> = URL(fileURLWithPath: path).getJSON()
        switch peopleResult {
        case .failure(let failure):
            return .failure(failure)
        case .success(let success):
            people = success
            return .success(success)
        }
    }

    public func getFilmPeople(of film: GhibliFilm) -> Result<[GhibliPeople], Error> {
        if let cachedFilmPeople = filmPeople[film.id] {
            return .success(cachedFilmPeople)
        }
        let people: [GhibliPeople]
        if self.people.isEmpty {
            let peopleResult = getPeople()
            switch peopleResult {
            case .failure(let failure):
                return .failure(failure)
            case .success(let success):
                people = success
                self.people = people
            }
        } else {
            people = self.people
        }
        let groupedPeople = Dictionary(grouping: people, by: (\.id))
        let currentFilmPeople: [GhibliPeople] = film.people.compactMap { groupedPeople[$0]?.first }
        filmPeople[film.id] = currentFilmPeople
        return .success(currentFilmPeople)
    }

    public enum Errors: Error {
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
