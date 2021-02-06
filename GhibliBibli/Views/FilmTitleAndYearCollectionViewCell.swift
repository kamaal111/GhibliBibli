//
//  FilmTitleAndYearCollectionViewCell.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 06/02/2021.
//

import UIKit

class FilmTitleAndYearCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(filmTitleLabel)
        self.addSubview(releaseYearLabel)
        self.addSubview(originalTitleLabel)

        NSLayoutConstraint.activate([
            filmTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            filmTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            filmTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),

            releaseYearLabel.topAnchor.constraint(equalTo: filmTitleLabel.bottomAnchor, constant: 8),
            releaseYearLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            releaseYearLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            originalTitleLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 8),
            originalTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            originalTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(title: String?, releaseYear: Int?, originalTitle: String?) {
        filmTitleLabel.text = title
        if let unwrappedReleaseYear = releaseYear {
            releaseYearLabel.text = "\(unwrappedReleaseYear)"
        }
        originalTitleLabel.text = originalTitle
    }

    private lazy var filmTitleLabel: UILabel = {
        let label = UILabel.filmTitleLabel(title: nil)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel.filmTitleLabel(title: nil)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

#if DEBUG
import SwiftUI
struct FilmTitleAndYearCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let viewCell = FilmTitleAndYearCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        viewCell.setData(title: "Title", releaseYear: 1994, originalTitle: "Original Title")
        return viewCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
