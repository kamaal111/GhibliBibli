//
//  HomeCollectionViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 26/01/2021.
//

import UIKit
import GhibliNet

private let filmCellReuseIdentifier = "FilmCell"

class HomeCollectionViewController: UICollectionViewController {

    private var networker: GhibliNet?

    var ghibliFilms: [GhibliFilm] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    convenience init(layout: UICollectionViewFlowLayout) {
        self.init(collectionViewLayout: layout)
        self.networker = GhibliNet()
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(FilmCellView.self, forCellWithReuseIdentifier: filmCellReuseIdentifier)

        self.collectionView.backgroundColor = .systemBackground
        self.title = "Ghibli Bibli"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        if ghibliFilms.isEmpty {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                guard let self = self else { return }
                guard let filmsResult = self.networker?.getFilms() else { return }
                switch filmsResult {
                case .failure(let failure):
                    print(failure.localizedDescription)
                case .success(let success):
                    self.ghibliFilms = success
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ghibliFilms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmCellReuseIdentifier, for: indexPath) as! FilmCellView
        let ghibliFilm = ghibliFilms[indexPath.row]
        cell.setFilm(ghibliFilm)
        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = calcuateCellWidth(from: collectionView.frame.size)
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

private extension HomeCollectionViewController {
    private func calcuateCellWidth(from size: CGSize) -> CGFloat {
        let cellMaxWidth: CGFloat
        if size.width > size.height {
            cellMaxWidth = size.height
        } else {
            cellMaxWidth = size.width
        }
        let cellWidth: CGFloat
        if UIDevice.current.userInterfaceIdiom == .phone {
            cellWidth = (cellMaxWidth / 2) - 30
        } else {
            cellWidth = (cellMaxWidth / 4) - 30
        }
        return cellWidth
    }
}

#if DEBUG
import SwiftUI
struct HomeCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: HomeCollectionViewController(layout: UICollectionViewFlowLayout()))
            .toSwiftUIView()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
