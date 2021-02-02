//
//  Playground.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 01/02/2021.
//

import SwiftUI
import GhibliNet

struct Playground: View {
    @State private var playgroundLoaded = false
    @State private var ghibliFilms: [GhibliFilm] = []

    private let networker = NetworkController.shared

    var body: some View {
        ZStack {
            if !playgroundLoaded {
                Text("Playground")
            } else {
                VStack {
                    NavigationLink(destination: FilmDetailPlayground(ghibliFilm: ghibliFilm)) {
                        HStack {
                            Text("Film Detail Screen")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(Font.body.bold())
                        }
                    }
                }
                .padding(.all, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .navigationBarTitle(Text("Playground"), displayMode: .inline)
            }
        }
        .onAppear(perform: {
            switch networker.ghibli.getFilms() {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                ghibliFilms = success
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { self.playgroundLoaded = true }
            }
        })
    }

    private var ghibliFilm: GhibliFilm? {
        ghibliFilms.shuffled().first { !$0.people.isEmpty }
    }
}

struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Playground()
        }
    }
}
