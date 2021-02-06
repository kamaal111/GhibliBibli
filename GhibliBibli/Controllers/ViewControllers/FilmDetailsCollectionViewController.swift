//
//  FilmDetailsCollectionViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 06/02/2021.
//

import UIKit
import GhibliNet

private let aboutSectionReuseIdentifier = "AboutSectionCell"
private let filmImageReuseIdentifier = "FilmImageCell"

class FilmDetailsCollectionViewController: UICollectionViewController {

    var ghibliFilm: GhibliFilm?

    private let networker = NetworkController.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: aboutSectionReuseIdentifier)
        self.collectionView.register(FilmImageCollectionViewCell.self, forCellWithReuseIdentifier: filmImageReuseIdentifier)

        self.navigationItem.largeTitleDisplayMode = .never
        self.title = ghibliFilm?.title
        self.collectionView.backgroundColor = .systemBackground
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                reuseIdentifier = filmImageReuseIdentifier
            } else {
                reuseIdentifier = aboutSectionReuseIdentifier
            }
        } else {
            reuseIdentifier = aboutSectionReuseIdentifier
        }
        let cell: UICollectionViewCell
        if reuseIdentifier != filmImageReuseIdentifier {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            if indexPath.section == 0 {
                cell.backgroundColor = .red
            } else {
                cell.backgroundColor = .green
            }
        } else {
            if let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilmImageCollectionViewCell {
                filmCell.setImage(ghibliFilm?.uiImage)
                cell = filmCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            }
        }
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilmDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return CGSize(width: (collectionView.frame.width / 2) - 16, height: collectionView.frame.width / 1.2)
            }
        }
        return CGSize(width: (collectionView.frame.size.width / 2) - 16, height: (collectionView.frame.size.width / 2) - 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
}

#if DEBUG
import SwiftUI
struct FilmDetailsCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: FilmDetailsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
            .toSwiftUIView()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
