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
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        FilmDetailsSections.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filmDetailsSection = FilmDetailsSections.allCases[section]
        switch filmDetailsSection {
        case .characters:
            guard !filmPeople.isEmpty else { return 0 }
            return filmDetailsSection.items.count + filmPeople.count - 1
        case .watchList, .details: return filmDetailsSection.items.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let filmDetailsItem = FilmDetailsItems.findByIndexPath(indexPath) else { return }
        switch filmDetailsItem {
        case .character:
            let characterDetailViewController = CharacterDetailViewController()
            characterDetailViewController.character = filmPeople[indexPath.row - 1]
            self.navigationController?.pushViewController(characterDetailViewController, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        case .watchListState:
            let partialSheetViewController = PartialSheetViewController(sheetHeight: self.view.frame.height / 3)
            partialSheetViewController.modalPresentationStyle = .custom
            present(partialSheetViewController, animated: true, completion: nil)
        case .characterHeader, .filmImage, .filmTitleAndReleaseYearReuse: break
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filmDetailsItem = FilmDetailsItems.findByIndexPath(indexPath) else {
            fatalError("cell not registered in FilmDetailsItems")
        }
        switch filmDetailsItem {
        case .filmImage:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmImageCollectionViewCell else {
                fatalError("could not cast cell as FilmImageCollectionViewCell")
            }
            cell.setImage(ghibliFilm?.uiImage)
            return cell
        case .filmTitleAndReleaseYearReuse:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmTitleAndYearCollectionViewCell else {
                fatalError("could not cast cell as FilmTitleAndYearCollectionViewCell")
            }
            cell.setData(title: ghibliFilm?.title, releaseYear: ghibliFilm?.releaseDate, originalTitle: ghibliFilm?.originalTitle)
            return cell
        case .watchListState:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath)
            return cell
        case .characterHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath)
            return cell
        case .character:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmDetailsItem.reuseIdentifier, for: indexPath) as? FilmCharacterButtonCollectionViewCell else {
                fatalError("could not cast cell as FilmCharacterButtonViewCell")
            }
            let filmPerson = filmPeople[indexPath.row - 1]
            cell.setText(filmPerson.name)
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

// MARK: - Internal methods

private extension FilmDetailsCollectionViewController {
    func popultePeople() {
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
}

// MARK: - Items configurations

private enum FilmDetailsItems: String, CaseIterable {
    case filmImage = "FilmImageCell"
    case filmTitleAndReleaseYearReuse = "FilmTitleAndReleaseYearCell"

    case watchListState = "WatchListStateCell"

    case characterHeader = "CharacterHeaderCell"
    case character = "CharacterCell"

    var reuseIdentifier: String { self.rawValue }

    var indexPath: IndexPath {
        switch self {
        case .filmImage, .filmTitleAndReleaseYearReuse:
            guard let section = FilmDetailsSections.allCases.firstIndex(of: .details),
                  let row = FilmDetailsSections.details.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in details section")
            }
            return IndexPath(row: row, section: section)
        case .watchListState:
            guard let section = FilmDetailsSections.allCases.firstIndex(of: .watchList),
                  let row = FilmDetailsSections.watchList.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in details section")
            }
            return IndexPath(row: row, section: section)
        case .characterHeader:
            guard let section = FilmDetailsSections.allCases.firstIndex(of: .characters),
                  let row = FilmDetailsSections.characters.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in character section")
            }
            return IndexPath(row: row, section: section)
        case .character:
            guard let section = FilmDetailsSections.allCases.firstIndex(of: .characters),
                  let row = FilmDetailsSections.characters.items.firstIndex(where: { $0 == self }) else {
                fatalError("could not find \(self.rawValue) in character section")
            }
            return IndexPath(row: row, section: section)
        }
    }

    var collectionViewCellType: UICollectionViewCell.Type {
        switch self {
        case .filmImage: return FilmImageCollectionViewCell.self
        case .filmTitleAndReleaseYearReuse: return FilmTitleAndYearCollectionViewCell.self
        case .watchListState: return WatchListStateCollectionViewCell.self
        case .characterHeader: return FilmCharactersSectionHeaderCollectionViewCell.self
        case .character: return FilmCharacterButtonCollectionViewCell.self
        }
    }

    func cellSize(collectionViewSize: CGSize) -> CGSize {
        let collectionViewWidth = collectionViewSize.width
        switch self {
        case .filmImage, .filmTitleAndReleaseYearReuse:
            return CGSize(width: (collectionViewWidth / 2) - 16, height: collectionViewWidth / 1.2)
        case .watchListState: return CGSize(width: collectionViewWidth - 16, height: 40)
        case .characterHeader, .character: return CGSize(width: collectionViewWidth - 32, height: 16)
        }
    }

    static func findByIndexPath(_ indexPath: IndexPath) -> FilmDetailsItems? {
        if indexPath.section == 1 && indexPath.row > 0 {
            return .character
        }
        return FilmDetailsItems.allCases.first { $0.indexPath == indexPath }
    }
}

class WatchListStateCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Sections configurations

private enum FilmDetailsSections: CaseIterable {
    case details
    case watchList
    case characters
}

extension FilmDetailsSections {
    var items: [FilmDetailsItems] {
        switch self {
        case .details: return [.filmImage, .filmTitleAndReleaseYearReuse]
        case .watchList: return [.watchListState]
        case .characters: return [.characterHeader, .character]
        }
    }

    var edgeInsets: UIEdgeInsets {
        switch self {
        case .details: return UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8)
        case .watchList: return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        case .characters: return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
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
