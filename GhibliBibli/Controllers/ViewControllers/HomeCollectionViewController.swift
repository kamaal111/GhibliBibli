//
//  HomeCollectionViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 26/01/2021.
//

import UIKit
import GhibliNet

private let reuseIdentifier = "Cell"
private let headerReuseIdentifier = "Header"

class HomeCollectionViewController: UICollectionViewController {

    private var preview: Bool?
    private var networker: GhibliNet?

    var ghibliFilms: [GhibliFilm] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    convenience init(layout: UICollectionViewFlowLayout, preview: Bool = false) {
        self.init(collectionViewLayout: layout)
        self.preview = preview
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

        self.collectionView.register(FilmCellView.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(HeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: headerReuseIdentifier)

        self.collectionView.backgroundColor = .systemBackground

        if ghibliFilms.isEmpty {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                guard let self = self else { return }
                switch self.networker!.getFilms() {
                case .failure(let failure):
                    print(failure.localizedDescription)
                case .success(let success):
                    self.ghibliFilms = success
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ghibliFilms.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilmCellView else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }
        cell.textLabel.text = ghibliFilms[indexPath.row].originalTitle
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
    }

}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 30, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 80)
        }
        return .zero
    }
}

#if DEBUG
import SwiftUI
struct HomeCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: HomeCollectionViewController(layout: UICollectionViewFlowLayout(), preview: true)).toSwiftUIView()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
