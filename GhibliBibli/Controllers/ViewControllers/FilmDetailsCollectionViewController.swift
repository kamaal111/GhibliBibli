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

    private var filmPeople: [GhibliPeople] = []

    private let networker = NetworkController.shared

    // MARK: - View lifecyle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        FilmDetailsItems.allCases.forEach {
            self.collectionView.register($0.collectionViewCellType, forCellWithReuseIdentifier: $0.reuseIdentifier)
        }

        self.navigationItem.largeTitleDisplayMode = .never
        self.title = ghibliFilm?.title
        self.collectionView.backgroundColor = .systemBackground

        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            if let ghibliFilm = self.ghibliFilm {
                switch self.networker.ghibli.getFilmPeople(of: ghibliFilm) {
                case .failure(let failure):
                    print(failure.localizedDescription)
                case .success(let success):
                    self.filmPeople = success
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        FilmDetailsSections.allCases.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filmDetailsSection = FilmDetailsSections.allCases[section]
        switch filmDetailsSection {
        case .characters:
            if filmPeople.isEmpty {
                return 0
            }
            return filmDetailsSection.items.count
        case .details:
            return filmDetailsSection.items.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filmDetailsItem = FilmDetailsItems.findByIndexPath(indexPath) else {
            fatalError("cell not registered in FilmDetailsItems")
        }
        switch filmDetailsItem {
        case .filmImage:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmImageCollectionViewCell else {
                fatalError("could not cast cell to FilmImageCollectionViewCell")
            }
            cell.setImage(ghibliFilm?.uiImage)
            return cell
        case .filmTitleAndReleaseYearReuse:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmTitleAndYearCollectionViewCell else {
                fatalError("could not cast cell to FilmTitleAndYearCollectionViewCell")
            }
            cell.setData(title: ghibliFilm?.title, releaseYear: ghibliFilm?.releaseDate, originalTitle: ghibliFilm?.originalTitle)
            return cell
        case .characterHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath)
            return cell
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
        FilmDetailsSections.allCases[section].edgeInsets
    }
}

// MARK: - Items configurations

private enum FilmDetailsItems: String, CaseIterable {
    case filmImage = "FilmImageCell"
    case filmTitleAndReleaseYearReuse = "FilmTitleAndReleaseYearCell"

    case characterHeader = "CharacterHeaderCell"
}

extension FilmDetailsItems {
    var reuseIdentifier: String { self.rawValue }

    var indexPath: IndexPath {
        switch self {
        case .filmImage, .filmTitleAndReleaseYearReuse:
            guard let section = FilmDetailsSections.allCases.firstIndex(of: .details),
                  let row = FilmDetailsSections.details.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in details section")
            }
            return IndexPath(row: row, section: section)
        case .characterHeader:
            guard let section = FilmDetailsSections.allCases.firstIndex(of: .characters),
                  let row = FilmDetailsSections.characters.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in character section")
            }
            return IndexPath(row: row, section: section)
        }
    }

    var collectionViewCellType: UICollectionViewCell.Type {
        switch self {
        case .filmImage:
            return FilmImageCollectionViewCell.self
        case .filmTitleAndReleaseYearReuse:
            return FilmTitleAndYearCollectionViewCell.self
        case .characterHeader:
            return FilmCharactersSectionHeaderCollectionViewCell.self
        }
    }

    func cellSize(collectionViewSize: CGSize) -> CGSize {
        switch self {
        case .filmImage, .filmTitleAndReleaseYearReuse:
            return CGSize(width: (collectionViewSize.width / 2) - 16, height: collectionViewSize.width / 1.2)
        case .characterHeader:
            return CGSize(width: collectionViewSize.width - 16, height: 20)
        }
    }

    static func findByIndexPath(_ indexPath: IndexPath) -> FilmDetailsItems? {
        FilmDetailsItems.allCases.first { $0.indexPath == indexPath }
    }
}

// MARK: - Sections configurations

private enum FilmDetailsSections: CaseIterable {
    case details
    case characters
}

extension FilmDetailsSections {
    var items: [FilmDetailsItems] {
        switch self {
        case .details:
            return [.filmImage, .filmTitleAndReleaseYearReuse]
        case .characters:
            return [.characterHeader]
        }
    }

    var edgeInsets: UIEdgeInsets {
        switch self {
        case .details:
            return UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8)
        case .characters:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
}

// MARK: - Preview

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
