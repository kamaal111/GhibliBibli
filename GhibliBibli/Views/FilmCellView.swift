//
//  FilmCellView.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 29/01/2021.
//

import UIKit
import GhibliNet

class FilmCellView: UICollectionViewCell {

    private var film: GhibliFilm? {
        didSet { populateViewWithFilm() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFilm(_ film: GhibliFilm) {
        self.film = film
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private func populateViewWithFilm() {
        guard let film = film else { return }
        filmImageView.image = film.uiImage
        titleLabel.text = film.title
        releaseYearLabel.text = "\(film.releaseDate)"
    }

    private func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(filmImageView)
        self.addSubview(releaseYearLabel)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: self.topAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filmImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            /// - TODO: Find a better solution for this 💩
            filmImageView.heightAnchor.constraint(equalToConstant: self.frame.height / 1.2),

            titleLabel.topAnchor.constraint(equalTo: filmImageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            releaseYearLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            releaseYearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }

}

#if DEBUG
import SwiftUI
struct FilmCellView_Previews: PreviewProvider {
    static var previews: some View {
        let filmCell = FilmCellView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        let ghibliFilm = try! NetworkController.shared.ghibli.getFilms().get().first!
        filmCell.setFilm(ghibliFilm)
        return filmCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
