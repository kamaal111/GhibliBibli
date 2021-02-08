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
    @State private var addedToList = false
    @State private var score = 0
    @State private var showScoreSheet = false

    let ghibliFilm: GhibliFilm?

    private let networker = NetworkController.shared

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
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
                HStack {
                    Button(action: { addedToList.toggle() }, label: {
                        Text(addedToList ? "Removed from list" : "Add to list")
                    })
                    Spacer()
                    Button(action: { showScoreSheet = true }, label: {
                        Text("Not scored")
                    })
                }
                .padding(.top, 24)
                VStack(alignment: .leading) {
                    Text("Characters")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    ForEach(ghibliPeople) { (person: GhibliPeople) in
                        NavigationLink(destination: Text(person.name)) {
                            HStack {
                                Text(person.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.vertical, 1)
                    }
                }
                .padding(.vertical, 16)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
        }
        .navigationBarTitle(Text(ghibliFilm?.title ?? ""), displayMode: .inline)
        .sheet(isPresented: $showScoreSheet, content: {
            Picker(selection: $score, label: Text("Picker"), content: {
                Text("1").tag(1)
                Text("2").tag(2)
            })
        })
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
