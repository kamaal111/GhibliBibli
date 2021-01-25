//
//  ViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import UIKit
import GhibliNet

class ViewController: UIViewController {

    let networker = GhibliNet()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ghibli Bibli"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        networker.getFilms { (result: Result<[GhibliFilm], Error>) in
            switch result {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                success.forEach { (film: GhibliFilm) in
                    print("film", film)
                }
            }
        }
    }

}
