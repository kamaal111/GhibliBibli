//
//  GhibliNet.swift
//  
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import XiphiasNet
import Foundation

public struct GhibliNet {
    private let networker: XiphiasNetable = XiphiasNet()

    let preview: Bool

    public init(preview: Bool = false) {
        self.preview = preview
    }

    public func getFilms(completion: @escaping (Result<[GhibliFilm], Error>) -> Void) {
        if preview {
            completion(.success(MockGhibliNet.getFilms))
            return
        }
        networker.request(from: GhibliEndpoint.films.url, completion: completion)
    }
}

struct MockGhibliNet {
    private init() { }

    static var getFilms: [GhibliFilm] {
        [
            GhibliFilm(id: UUID(),
                       title: "When Marnie Was There",
                       description: "The film follows Anna Sasaki living with her relatives in the seaside town." +
                        "Anna comes across a nearby abandoned mansion, where she meets Marnie, a mysterious girl who" +
                        "asks her to promise to keep their secrets from everyone. As the summer progresses, Anna" +
                        "spends more time with Marnie, and eventually Anna learns the truth about her family and" +
                        "foster care.",
                       director: "Hiromasa Yonebayashi",
                       producer: "Yoshiaki Nishimura",
                       releaseDate: "2014",
                       rtScore: "92",
                       people: [URL(string: "fake")!],
                       species: [URL(string: "fake")!],
                       locations: [URL(string: "fake")!],
                       url: URL(string: "fake")!,
                       vehicles: [URL(string: "fake")!])]
    }
}

struct GhibliEndpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension GhibliEndpoint {
    static var films: GhibliEndpoint {
        GhibliEndpoint(path: "films")
    }

    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "ghibliapi.herokuapp.com"
        components.path = "/\(path)"
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}
