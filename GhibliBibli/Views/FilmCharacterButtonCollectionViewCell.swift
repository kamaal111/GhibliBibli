//
//  FilmCharacterButtonCollectionViewCell.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 06/02/2021.
//

import UIKit

class FilmCharacterButtonCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),

            imageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                imageView.alpha = 0.4
                label.alpha = 0.4
            } else {
                imageView.alpha = 1
                label.alpha = 1
            }
        }
    }

    func setText(_ text: String) {
        label.text = text
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    lazy var imageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

}

#if DEBUG
import SwiftUI
struct FilmCharacterButtonCollectionViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let viewCell = FilmCharacterButtonCollectionViewCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 350)))
        viewCell.setText("Character")
        return viewCell.toSwiftUIView().previewLayout(.sizeThatFits)
    }
}
#endif
