//
//  FilmDetailsViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 30/01/2021.
//

import UIKit
import GhibliNet

class FilmDetailsViewController: UIViewController {

    var ghibliFilm: GhibliFilm?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .accentColor
        self.title = ghibliFilm?.title
        self.navigationItem.largeTitleDisplayMode = .never
    }

}
