//
//  FilmCharactersSectionHeaderCollectionViewCell.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 06/02/2021.
//

import UIKit

class FilmCharactersSectionHeaderCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    lazy var label: UILabel = {
        let label = UILabel.sectionHeader(text: "Characters")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = false
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

#if DEBUG
import SwiftUI
struct FilmCharactersSectionHeaderCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let viewCell = FilmCharactersSectionHeaderCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        return viewCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
