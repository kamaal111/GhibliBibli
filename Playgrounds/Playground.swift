//
//  Playground.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 01/02/2021.
//

import SwiftUI
import GhibliNet

struct Playground: View {
    @State private var ghibliFilms: [GhibliFilm] = []

    private let networker = GhibliNet()

    var body: some View {
        VStack {
            NavigationLink(destination: FilmDetailPlayground(ghibliFilm: ghibliFilms.randomElement())) {
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
        .onAppear(perform: {
            switch networker.getFilms() {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                ghibliFilms = success
            }
        })
    }
}

struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Playground()
        }
    }
}
