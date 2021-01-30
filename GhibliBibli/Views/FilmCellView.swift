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
        didSet {
            guard let film = film else { return }
            filmImageView.image = film.uiImage
            textLabel.text = film.title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textLabel)
        self.addSubview(filmImageView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFilm(_ film: GhibliFilm) {
        self.film = film
    }

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private func setConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: self.topAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filmImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            /// - TODO: Find a better solution for this 💩
            filmImageView.heightAnchor.constraint(equalToConstant: self.frame.height / 1.2),
            textLabel.topAnchor.constraint(equalTo: filmImageView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

}

#if DEBUG
import SwiftUI
struct FilmCellView_Previews: PreviewProvider {
    static var previews: some View {
        let filmCell = FilmCellView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        let networker = GhibliNet()
        let ghibliFilm = try! networker.getFilms().get().randomElement()!
        filmCell.setFilm(ghibliFilm)
        return filmCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
