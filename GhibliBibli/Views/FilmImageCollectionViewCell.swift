//
//  FilmImageCollectionViewCell.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 06/02/2021.
//

import UIKit

class FilmImageCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(filmImageView)

        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            filmImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            filmImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        filmImageView.image = image
    }

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView.filmImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

}

#if DEBUG
import SwiftUI
struct FilmImageCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let filmCell = FilmImageCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        let ghibliFilm = try! NetworkController.shared.ghibli.getFilms().get().first!
        filmCell.setImage(ghibliFilm.uiImage)
        return filmCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
