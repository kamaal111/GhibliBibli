//
//  FilmDetailPlayground.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 01/02/2021.
//

import SwiftUI
import GhibliNet

struct FilmDetailPlayground: View {
    @State private var ghibliPeople: [GhibliPeople] = []

    let ghibliFilm: GhibliFilm?

    private let networker = NetworkController.shared

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if ghibliFilm?.uiImage != nil {
                    Image(uiImage: ghibliFilm!.uiImage!)
                        .resizable()
                        .frame(width: UIScreen.main.narrowestEdge / 2.5, height: UIScreen.main.widestEdge / 2.5)
                        .shadow(color: Color.accentColor.opacity(0.6), radius: 4, x: 4, y: 4)
                }
                VStack(alignment: .leading) {
                    Text(ghibliFilm?.title ?? "")
                        .font(.title3)
                    Text(releaseYearText)
                        .foregroundColor(.secondary)
                    Text(ghibliFilm?.originalTitle ?? "")
                        .font(.headline)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            VStack(alignment: .leading) {
                ForEach(ghibliPeople) { person in
                    Text(person.name)
                }
            }
            .padding(.vertical, 16)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarTitle(Text(ghibliFilm?.title ?? ""), displayMode: .inline)
        .onAppear(perform: {
            if let ghibliFilm = ghibliFilm {
                switch networker.ghibli.getFilmPeople(of: ghibliFilm) {
                case .failure(let failure):
                    print(failure.localizedDescription)
                case .success(let success):
                    ghibliPeople = success
                }
            }
        })
    }

    private var releaseYearText: String {
        guard let releaseDate = ghibliFilm?.releaseDate else { return "" }
        return "\(releaseDate)"
    }
}

struct FilmDetailPlayground_Previews: PreviewProvider {
    static var previews: some View {
        let ghibliFilm = try? NetworkController.shared.ghibli.getFilms().get().first { !$0.people.isEmpty }
        return NavigationView {
            FilmDetailPlayground(ghibliFilm: ghibliFilm)
        }
    }
}
