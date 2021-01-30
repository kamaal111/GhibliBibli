//
//  GhibliFilmsModelController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 30/01/2021.
//

import GhibliNet

class GhibliFilmsModelController {
    private var ghibliFilmsModel = GhibliFilmsModel()

    var ghibliFilms: [GhibliFilm] {
        ghibliFilmsModel.ghibliFilms
    }

    func setFilms(with films: [GhibliFilm]) {
        ghibliFilmsModel.ghibliFilms = films
    }
}
