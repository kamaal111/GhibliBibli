//
//  FilmDetailsCollectionViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 06/02/2021.
//

import UIKit
import GhibliNet

class FilmDetailsCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    var ghibliFilm: GhibliFilm?

    private let networker = NetworkController.shared

    // MARK: - View lifecyle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(FilmImageCollectionViewCell.self, forCellWithReuseIdentifier: FilmDetailsItems.filmImage.reuseIdentifier)
        self.collectionView.register(FilmTitleAndYearCollectionViewCell.self, forCellWithReuseIdentifier: FilmDetailsItems.filmTitleAndReleaseYearReuse.reuseIdentifier)

        self.navigationItem.largeTitleDisplayMode = .never
        self.title = ghibliFilm?.title
        self.collectionView.backgroundColor = .systemBackground
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { FilmDetailsSections.allCases.count }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        FilmDetailsSections.allCases[section].items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filmDetailsItem = FilmDetailsItems.findByIndexPath(indexPath) else {
            fatalError("cell not registered in FilmDetailsItems")
        }
        switch filmDetailsItem {
        case .filmImage:
            guard let filmImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmImageCollectionViewCell else {
                fatalError("could not cast cell to FilmImageCollectionViewCell")
            }
            filmImageCell.setImage(ghibliFilm?.uiImage)
            return filmImageCell
        case .filmTitleAndReleaseYearReuse:
            guard let filmTitleAndReleaseYearCell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmTitleAndYearCollectionViewCell else {
                fatalError("could not cast cell to FilmTitleAndYearCollectionViewCell")
            }
            filmTitleAndReleaseYearCell.setData(title: ghibliFilm?.title, releaseYear: ghibliFilm?.releaseDate, originalTitle: ghibliFilm?.originalTitle)
            return filmTitleAndReleaseYearCell
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilmDetailsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let filmDetailsItem = FilmDetailsItems.findByIndexPath(indexPath) else {
            fatalError("cell not registered in FilmDetailsItems")
        }
        return filmDetailsItem.cellSize(collectionViewSize: collectionView.frame.size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
}

private enum FilmDetailsItems: String, CaseIterable {
    case filmImage = "FilmImageCell"
    case filmTitleAndReleaseYearReuse = "FilmTitleAndReleaseYearCell"
}

extension FilmDetailsItems {
    var reuseIdentifier: String { self.rawValue }

    var indexPath: IndexPath {
        switch self {
        case .filmImage, .filmTitleAndReleaseYearReuse:
            guard let row = FilmDetailsSections.details.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in details section")
            }
            return IndexPath(row: row, section: 0)
        }
    }

    func cellSize(collectionViewSize: CGSize) -> CGSize {
        switch self {
        case .filmImage, .filmTitleAndReleaseYearReuse:
            return CGSize(width: (collectionViewSize.width / 2) - 16, height: collectionViewSize.width / 1.2)
        }
    }

    static func findByIndexPath(_ indexPath: IndexPath) -> FilmDetailsItems? {
        FilmDetailsItems.allCases.first { $0.indexPath == indexPath }
    }
}

private enum FilmDetailsSections: CaseIterable {
    case details
}

extension FilmDetailsSections {
    var items: [FilmDetailsItems] {
        switch self {
        case .details:
            return [.filmImage, .filmTitleAndReleaseYearReuse]
        }
    }
}

#if DEBUG
import SwiftUI
struct FilmDetailsCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        let collectionViewControlller = FilmDetailsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewControlller.ghibliFilm = try? GhibliNet().getFilms().get().first { !$0.people.isEmpty }
        return UINavigationController(rootViewController: collectionViewControlller)
            .toSwiftUIView()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
