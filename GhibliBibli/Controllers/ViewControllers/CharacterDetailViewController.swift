//
//  CharacterDetailViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 02/02/2021.
//

import UIKit
import GhibliNet

class CharacterDetailViewController: UIViewController {

    var character: GhibliPeople?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = character?.name
    }

}
