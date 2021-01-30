//
//  FilmCellView.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 29/01/2021.
//

import UIKit

class FilmCellView: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textLabel)
        self.addSubview(filmImageView)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filmImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            filmImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            filmImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            filmImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

}

#if DEBUG
import SwiftUI
struct FilmCellView_Previews: PreviewProvider {
    static var previews: some View {
        let filmCell = FilmCellView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        filmCell.textLabel.text = "Movie"
        return filmCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
