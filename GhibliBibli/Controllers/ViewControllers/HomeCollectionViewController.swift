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

    private var networker = GhibliNet()
    private var ghibliFilmsModelController = GhibliFilmsModelController()

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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

        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            switch self.networker.getFilms() {
            case .failure(let failure):
                print(failure.localizedDescription)
            case .success(let success):
                self.ghibliFilmsModelController.setFilms(with: success)
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    #if DEBUG
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let actionSheet = UIAlertController(title: "Secret Sheet", message: nil, preferredStyle: .actionSheet)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in }
            actionSheet.addAction(cancelActionButton)
            let playgroundActionButton = UIAlertAction(title: "Playground", style: .default) { (_: UIAlertAction) in
                let playgroundScreen = Playground()
                let hostingController = UIHostingController(rootView: playgroundScreen)
                self.navigationController?.pushViewController(hostingController, animated: true)
            }
            actionSheet.addAction(playgroundActionButton)
            self.present(actionSheet, animated: true)
        }
    }
    #endif

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ghibliFilmsModelController.ghibliFilms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filmCellReuseIdentifier, for: indexPath) as! FilmCellView
        let ghibliFilm = ghibliFilmsModelController.ghibliFilms[indexPath.row]
        cell.setFilm(ghibliFilm)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filmDetailsViewController = FilmDetailsViewController()
        let ghibliFilm = ghibliFilmsModelController.ghibliFilms[indexPath.row]
        filmDetailsViewController.ghibliFilm = ghibliFilm
        self.navigationController?.pushViewController(filmDetailsViewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = calcuateCellWidth(from: collectionView.frame.size)
        return CGSize(width: cellWidth, height: cellWidth * 1.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 8, bottom: 15, right: 8)
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
            cellWidth = (cellMaxWidth / 2) - 16
        } else {
            cellWidth = (cellMaxWidth / 4) - 16
        }
        return cellWidth
    }
}

#if DEBUG
import SwiftUI
struct HomeCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: HomeCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
            .toSwiftUIView()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
