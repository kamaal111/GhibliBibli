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

    private let networker = NetworkController.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.shadowColor = UIColor.accentColor.cgColor
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.shadowRadius = 4
        imageView.clipsToBounds = false
        imageView.image = ghibliFilm?.uiImage
        return imageView
    }()

    private lazy var filmTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = ghibliFilm?.title
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()

    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        if let releaseDate = ghibliFilm?.releaseDate {
            label.text = "\(releaseDate)"
        }
        return label
    }()

    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = ghibliFilm?.originalTitle
        label.font = .preferredFont(forTextStyle: .headline)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.addSubview(filmImageView)
        self.view.addSubview(filmTitleLabel)
        self.view.addSubview(releaseYearLabel)
        self.view.addSubview(originalTitleLabel)
        setupConstraints()
        if let ghibliFilm = ghibliFilm {
            self.title = ghibliFilm.title

            switch networker.ghibli.getFilmPeople(of: ghibliFilm) {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                print(success)
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filmImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filmImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.widestEdge / 2.5),
            filmImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.narrowestEdge / 2.5),
            filmTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            filmTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filmTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            releaseYearLabel.topAnchor.constraint(equalTo: filmTitleLabel.bottomAnchor, constant: 8),
            releaseYearLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            originalTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            originalTitleLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 8)
        ])
    }

}

#if DEBUG
import SwiftUI
struct FilmDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let filmDetailViewController = FilmDetailsViewController()
        let ghibliFilm = try? GhibliNet().getFilms().get().first
        filmDetailViewController.ghibliFilm = ghibliFilm
        return Group {
            UINavigationController(rootViewController: filmDetailViewController)
                .toSwiftUIView()
                .edgesIgnoringSafeArea(.all)
                .colorScheme(.dark)
        }
    }
}
#endif
