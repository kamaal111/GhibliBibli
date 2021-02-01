//
//  FilmDetailPlayground.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 01/02/2021.
//

import SwiftUI
import GhibliNet

struct FilmDetailPlayground: View {
    let ghibliFilm: GhibliFilm?

    var body: some View {
        VStack {
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
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationBarTitle(Text(ghibliFilm?.title ?? ""), displayMode: .inline)
    }

    private var releaseYearText: String {
        guard let releaseDate = ghibliFilm?.releaseDate else { return "" }
        return "\(releaseDate)"
    }
}

struct FilmDetailPlayground_Previews: PreviewProvider {
    static var previews: some View {
        let ghibliFilm = try? GhibliNet().getFilms().get().first
        return NavigationView {
            FilmDetailPlayground(ghibliFilm: ghibliFilm)
        }
    }
}
